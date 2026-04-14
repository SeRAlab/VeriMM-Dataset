module down_counter (
    input clk,
    input rst,
    input [3:0] init_value,
    output reg [3:0] count
);
    always @(posedge clk or posedge rst) begin
        if (rst) 
            count <= init_value;
        else if (count > 0) 
            count <= count - 1;
    end
endmodule