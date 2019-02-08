import java.io.File

import com.typesafe.config._


object Main extends App {

  if (args.length == 1) {

    val filename = args(0)
    val config = ConfigFactory.parseFile(new File(filename))

    println(
      config
        .resolve(ConfigResolveOptions.noSystem())
        .root()
        .render(ConfigRenderOptions.defaults().setJson(true).setComments(false).setOriginComments(false))
    )

  } else {
    println("one parameter needed: hocon file")
  }

}

