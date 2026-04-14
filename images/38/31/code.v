module shift_register (
    input clk,
    input rst,
    input clr,
    input [1:0] data_in,
    output reg [1:0] data_out
);
    
    always @(posedge clk or posedge rst or posedge clr) begin
        if (rst) begin
            data_out <= 2'b00;
        end else if (clr) begin
            data_out <= 2'b00;
        end else begin
            data_out <= {data_out[0], data_in[1]}; // Shift left
        end
    end
endmodule