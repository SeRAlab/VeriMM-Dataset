module VCO (
    input [3:0] ctrl_voltage,
    output reg [6:0] out_freq
);
    always @(ctrl_voltage) begin
        out_freq <= {3'b000, ctrl_voltage} + 7'b0000000; // simple frequency mapping
    end
endmodule