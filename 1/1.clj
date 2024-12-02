(require '[clojure.string :as str])

(defn load-input-data [path]
  (defn process [lst] (vec (sort (map Integer/parseInt lst))))
  (let [pairs (map #(str/split % #"   ") (str/split-lines (slurp path)))]
    [(process (map first pairs)) (process (map second pairs))]))

(defn calculate [left right]
  (loop [i 0 sum 0]
    (if (>= i (count left))
      sum
      (recur
        (inc i)
        (+ sum (abs (- (get right i) (get left i))))))))

(let [data (load-input-data "1.txt")]
  (println (calculate (first data) (second data))))
