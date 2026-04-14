module shift_register (
    input wire clk,
    input wire reset,
    input wire shift,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    always @(posedge clk) begin
        if (reset) begin
            data_out <= 4'b0000; // Reset the register
        end else if (shift) begin
            data_out <= {data_in[0], data_out[3:1]}; // Shift right
        end
    end
endmodule