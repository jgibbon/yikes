import pyotherside

class testclass:
  def __init__(self):
    self.var1 = "first py var"
    self.var2 = "second py var"
    pyotherside.send("init", self.var1, self.var2)


  def debugoutput(self):
    pyotherside.send("debugoutput", self.var1, self.var2)
    

testinstance = testclass()
