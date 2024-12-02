(require '[clojure.string :as str])

; Same as from Day 1
(defn load-input-data [path]
  (defn process [lst] (vec (sort (map Integer/parseInt lst))))
  (let [pairs (map #(str/split % #"   ") (str/split-lines (slurp path)))]
    [(process (map first pairs)) (process (map second pairs))]))

; Count the occurences of val in a sorted list
(defn count-occurences [lst val]
  (let [idx (.indexOf lst val)]
    (if (= -1 idx)
      0 ; not found in the list at all
      (loop [i (inc idx) cnt 1]
        (if (or (>= i (count lst)) (not= (get lst i) val))
          cnt
          (recur
            (inc i)
            (+ cnt 1)))))))

(defn calculate [left right]
  (loop [i 0 score 0]
    (if (>= i (count left))
      score
      (recur
        (inc i)
        (let [val (get left i)]
          (+ score
            (* val (count-occurences right val))))))))


(let [data (load-input-data "1.txt")]
  (println (calculate (first data) (second data))))

