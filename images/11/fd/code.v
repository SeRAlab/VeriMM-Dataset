module pipo_shift_register (
    input wire clk,
    input wire load,
    input wire shift,
    input wire [4:0] data_in,
    output reg [4:0] data_out
);
    always @(posedge clk) begin
        if (load) begin
            data_out <= data_in; // Load data in parallel
        end else if (shift) begin
            data_out <= {1'b0, data_out[4:1]}; // Shift right, insert 0
        end
    end
endmodule