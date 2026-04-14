module siso_shift_register (
    input wire clk,
    input wire reset,
    input wire data_in,
    output reg [4:0] data_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 5'b00000;
        end else begin
            data_out <= {data_out[3:0], data_in};  // Shift left and insert new bit
        end
    end
endmodule