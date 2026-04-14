module top_module(
    counter_sel,
    intossd_2d,
    intossd_3d,
    lightctl_2d,
    lightctl_3d,
    intossd_out,
    light_ctl_out,
    stop_2d,
    stop_3d,
    stop_out
    );input counter_sel;
    input [3:0]intossd_2d;
    input [3:0]intossd_3d;
    input [3:0]lightctl_2d;
    input [3:0]lightctl_3d;
    input stop_2d;
    input stop_3d;

    output reg [3:0]intossd_out;
    output reg [3:0]light_ctl_out;
    output reg stop_out;

    always @*
    case (counter_sel)
        1'b0:
        begin
            intossd_out = intossd_2d;
            light_ctl_out = lightctl_2d;
            stop_out = stop_2d;
        end
        1'b1:
        begin
            intossd_out = intossd_3d;
            light_ctl_out = lightctl_3d;
            stop_out = stop_3d;
        end
        default:
        begin
            intossd_out = intossd_2d;
            light_ctl_out = lightctl_2d;
            stop_out = stop_2d;
        end
    endcase
endmodule