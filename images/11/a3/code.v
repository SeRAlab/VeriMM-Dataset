module shift_register (
    input clk,
    input rst,
    input load,
    input [1:0] data_in,
    output reg [1:0] data_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 2'b00;
        end else if (load) begin
            data_out <= data_in;
        end else begin
            data_out <= {data_out[0], 1'b0}; // Shift left and fill LSB with 0
        end
    end
endmodule