module shift_register (
    input clk,
    input reset,
    input data_in,
    output reg [7:0] data_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'b00000000;
        end else begin
            data_out <= {data_out[6:0], data_in}; // Shift left and insert new bit
        end
    end
endmodule