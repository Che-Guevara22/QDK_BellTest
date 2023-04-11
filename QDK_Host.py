import qsharp
from bell import RunAB, RunAC, RunBC

p_ab = RunAB.simulate(name="P(a,b)")
p_ac = RunAC.simulate(name="P(a,c)")
p_bc = RunBC.simulate(name="P(b,c)")

print("Bell's inequality |P(a,b)-P(a,c)| - P(b,c) ≤ 1")
op = ">" if abs(p_ab - p_ac) - p_bc > 1 else "≤"
print(f"|{p_ab}-{p_ac}| - {p_bc} = {(abs(p_ab - p_ac) - p_bc)} {op} 1")