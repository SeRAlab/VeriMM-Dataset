module top_module(
    input [3:0] binary_in,
    input reset,
    input scan_in,
    output reg [1:0] binary_out,
    output reg scan_out
);always @ (posedge reset) begin
        if (reset) begin
            binary_out <= 2'b00;
        end else begin
            binary_out <= binary_in[3:2];
        end
    end
    
    assign scan_out = scan_in;

endmodule