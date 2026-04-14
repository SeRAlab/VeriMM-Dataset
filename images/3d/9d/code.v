module shift_register (
    input wire [3:0] data_in,
    input wire clk,
    input wire load,
    input wire shift,
    output reg [3:0] data_out
);
    always @(posedge clk) begin
        if (load) begin
            data_out <= data_in; // Load data_in into register
        end else if (shift) begin
            data_out <= {1'b0, data_out[3:1]}; // Shift right
        end
    end
endmodule