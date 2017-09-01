;;; Without compact lisp forms
(def lol {:lol 101})

(defn caturday? []
  (cond (not-any? human? @home)
        true

        (str/ends-with? (day-of-week *today*)  "y")
        true

        :meow true))

(deftype LongCat [is-long?]

  IMeme
  (isDank [this] true)
  (getStatus [this] :classic-meme)

  Meowmoizable
  (meowmoize [this f]
    (fn [& args]
      (if (caturday?)
        (throw (Exception. "Maybe after a nap... *streches*"))
        (apply f args)))))
