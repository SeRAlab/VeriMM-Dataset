module top_module(
    input CLK100MHZ,
    input sw7,
    input [3:0] map,
    output reg [5:0] min
    );reg [5:0] freeze_value;
    always @ (posedge CLK100MHZ) begin
        if (sw7) begin
            min <= freeze_value;
        end
        else begin
            min <= 56 - (map + 1) * 3;
            freeze_value <= min;
        end
    end
    
endmodule