"""
Example of generating a 3D prism mesh with topography
"""
try:
    from mayavi import mlab
except ImportError:
    from enthought.mayavi import mlab
from matplotlib import pyplot
from fatiando import utils, gridder, logger, vis
from fatiando.mesher.volume import PrismMesh3D

# Avoid importing mlab twice since it's very slow
vis.mlab = mlab

log = logger.get()
log.info(logger.header())
log.info("Example of generating a 3D prism mesh with topography")

x1, x2 = -100, 100
y1, y2 = -200, 200
bounds = (x1, x2, y1, y2, -200, 0)

log.info("Generating synthetic topography")
x, y = gridder.regular((x1, x2, y1, y2), (50,50))
height = (100 +
          -50*utils.gaussian2d(x, y, 100, 200, x0=-50, y0=-100, angle=-60) +
          100*utils.gaussian2d(x, y, 50, 100, x0=80, y0=170))

pyplot.figure()
pyplot.title("Synthetic topography")
pyplot.axis('scaled')
vis.pcolor(x, y, height, (50,50))
pyplot.colorbar()
pyplot.show()

log.info("Generating the prism mesh")
mesh = PrismMesh3D(bounds, (20,40,20))
mesh.carvetopo(x, y, height)

log.info("Plotting")
mlab.figure(bgcolor=(1,1,1))
vis.prisms3D(mesh, (0 for i in xrange(mesh.size)))
outline = mlab.outline(color=(0,0,0), extent=bounds)
vis.add_axes3d(outline)
vis.wall_north(bounds)
mlab.show()
