module shift_register (
    input clk,
    input rst,
    input [1:0] data_in,
    output reg [1:0] data_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 2'b00;
        end else begin
            data_out <= {data_in[0], data_out[1]};
        end
    end
endmodule