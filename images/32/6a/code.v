module down_counter #(parameter N = 4) (
    input clk,
    input rst,
    input [N-1:0] start_value,
    output reg [N-1:0] count
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= start_value;
        end else if (count > 0) begin
            count <= count - 1;
        end
    end
endmodule