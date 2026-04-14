module shift_register (
    input clk,
    input shift,
    input [1:0] data_in,
    output reg [1:0] data_out
);
    always @(posedge clk) begin
        if (shift) begin
            data_out <= {1'b0, data_out[1]}; // Shift right and fill with 0
        end else begin
            data_out <= data_in; // Load new data
        end
    end
endmodule