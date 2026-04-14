module PIPO_Shift_Register (
    input clk,
    input reset,
    input load,
    input [7:0] parallel_in,
    output reg [7:0] parallel_out,
    output reg serial_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            parallel_out <= 8'b0;
            serial_out <= 1'b0;
        end else if (load) begin
            parallel_out <= parallel_in;
        end else begin
            serial_out <= parallel_out[0];
            parallel_out <= {1'b0, parallel_out[7:1]}; // Shift right
        end
    end
endmodule