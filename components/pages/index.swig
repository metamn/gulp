---
title: YAML
---

<p>{{ title }}</p>


{% for i in [1, 2, 3, 4, 5, 6] %}
  {{ i }}
{% endfor %}


{% include "../atoms/test.html" with { name : "lolka y bolka: ahoy!" } %}
