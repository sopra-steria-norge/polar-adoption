package no.steria.server;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.handler.HandlerList;
import org.eclipse.jetty.webapp.WebAppContext;

public class PingServer {

    private final Integer port;
    private String warFile;

    public PingServer(Integer port, String warFile) {
        this.port = port;
        this.warFile = warFile;
    }

    public static void main(String[] args) throws Exception {

        String warFile = null;
        if (args.length > 0) {
            warFile = args[0];
        }
        new PingServer(getPort(8081),warFile).start();
    }

    private void start() throws Exception {
        Server server = new Server(port);
        if (warFile != null) {
            WebAppContext webAppContext = new WebAppContext();
            webAppContext.setContextPath("/");
            webAppContext.setWar(warFile);
            server.setHandler(webAppContext);
        } else {
            HandlerList handlerList = new HandlerList();
            //handlerList.addHandler(new ShutdownHandler("yablayabla", false, true));
            handlerList.addHandler(new WebAppContext("src/main/webapp", "/"));
            server.setHandler(handlerList);
        }
        server.start();
        System.out.println("Running");
    }

    private static int getPort(int defaultPort) {
        return defaultPort;
    }
}