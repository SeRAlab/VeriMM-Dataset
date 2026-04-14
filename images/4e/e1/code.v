module johnson_counter_3bit (clk, rst, q);
   input clk, rst;
   output [2:0] q;
   
   reg [2:0] q;

always @(posedge clk or posedge rst) begin
    if (rst) 
    begin
        q <= 3'b000;
    end 
    else 
    begin
        q <= {q[1:0], ~q[2]};
    end
end

endmodule