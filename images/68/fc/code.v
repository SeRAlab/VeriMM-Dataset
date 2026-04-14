module top_module(
    input cpu_clock,
    input memreg_rd,
    input [10:0] a,
    input din,
    input volports_enabled,
    input port_wr,
    output reg snd_wrtoggle,
    output reg snd_datnvol,
    output reg [2:0] snd_addr,
    output reg [7:0] snd_data,
    input [2:0] volnum
);reg mode_8chans;

always @ (posedge cpu_clock) begin
    if (memreg_rd) begin
        snd_wrtoggle <= ~snd_wrtoggle;
        snd_datnvol <= 1'b1;
        if (!mode_8chans) begin
            snd_addr <= {1'b0, a[9:8]};
        end else begin
            snd_addr <= a[10:8];
        end
        snd_data <= din;
    end else if (volports_enabled && port_wr) begin
        snd_wrtoggle <= ~snd_wrtoggle;
        snd_datnvol <= 1'b0;
        snd_addr <= volnum;
        snd_data <= din;
    end
end

endmodule