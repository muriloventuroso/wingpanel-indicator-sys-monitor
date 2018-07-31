public class SysMonitor.Services.Net  : GLib.Object {
    private int _bytes_in;
    private int _bytes_in_old;

    private int _bytes_out;
    private int _bytes_out_old;

    public Net () {
        _bytes_in = 0;
        _bytes_in_old = 0;
        _bytes_out = 0;
        _bytes_out_old = 0;
    }

    public int bytes_out {
        get { update_bytes_total (); return _bytes_out; }
    }

    public int bytes_in {
        get { update_bytes_total (); return _bytes_in; }
    }

    construct {
    }

    private void update_bytes_total () {
        GTop.NetList netlist;
        GTop.NetLoad netload;

        var devices = GTop.get_netlist (out netlist);
        var n_bytes_out = 0;
        var n_bytes_in = 0;
        for (uint j = 0; j < netlist.number; ++j) {
            var device = devices[j];
            if(device != "lo"){
                GTop.get_netload (out netload, device);

                n_bytes_out += (int) netload.bytes_out;
                n_bytes_in += (int) netload.bytes_in;
            }
        }
        _bytes_out = (n_bytes_out - _bytes_out_old) / 1;
        _bytes_in = (n_bytes_in - _bytes_in_old) / 1;
        _bytes_out_old = n_bytes_out;
        _bytes_in_old = n_bytes_in;

    }

}