class BB.Collections.EventFiles extends Backbone.Collection

  model: BB.Models.EventFile

  comparator: (par1, par2) ->
    up1 = par1.get('updated_at')
    up2 = par2.get('updated_at')
    return 0  if up1 == up2
    return 1  if up1 < up2
    return -1
