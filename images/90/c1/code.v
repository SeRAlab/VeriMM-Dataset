module up_counter_4bit(
    input clk,
    input rst,
    input en,
    output reg [3:0] count
);

always @(posedge clk) begin
    if (rst) 
        count <= 4'd0;
    else if (en)
        count <= (count == 4'd15) ? 4'd0 : count + 1;
end

endmodule