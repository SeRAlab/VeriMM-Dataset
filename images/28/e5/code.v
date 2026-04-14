module shift_register (
    input wire clk,
    input wire reset,
    input wire shift,
    input wire shift_right,
    input wire load,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 16'b0;
        end else if (load) begin
            data_out <= data_in;
        end else if (shift) begin
            data_out <= {data_out[14:0], 1'b0}; // Shift left
        end else if (shift_right) begin
            data_out <= {1'b0, data_out[15:1]}; // Shift right
        end
    end
endmodule