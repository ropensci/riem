# riem_measures fails if required 'station' param is absent

    argument "station" is missing, with no default

# riem_measures fails if required 'date_start' param is absent

    argument "date_start" is missing, with no default

# riem_measures validates 'station' param

    `station` must be a string.

---

    HTTP 422 Unprocessable Entity.

# riem_measures validates dates

    x Invalid `date_start`: somethingelse.
    i Correct format is YYYY-MM-DD.

---

    x Invalid `date_start`: 2015 31 01.
    i Correct format is YYYY-MM-DD.

---

    x Invalid `date_end`: somethingelse.
    i Correct format is YYYY-MM-DD.

---

    x Invalid `date_end`: 2015 31 01.
    i Correct format is YYYY-MM-DD.

---

    `date_end` must be bigger than `date_start`.

# riem_measures validates 'elev' param

    `elev` must be a logical (TRUE/FALSE)

---

    `elev` must be a logical (TRUE/FALSE)

# riem_measures validates 'latlon' param

    `latlon` must be a logical (TRUE/FALSE)

---

    `latlon` must be a logical (TRUE/FALSE)

# riem_measures validates 'report_type' param

    `report_type` must be one of "hfmetar", "routine", or "specials", not "11111".

---

    `report_type` must be one of "hfmetar", "routine", or "specials", not "zzzzz".

---

    `report_type` must be one of "hfmetar", "routine", or "specials", not "zzzzz".

