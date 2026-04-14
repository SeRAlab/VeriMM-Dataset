module counter_4bit (clk, rst, en, count);
   input clk, rst, en;
   output [3:0] count;
   
   reg [3:0] count;

always @(posedge clk or posedge rst) begin
    if (rst) 
    begin
        count <= 0;
    end 
    else if (en) 
    begin
        count <= count + 1;
    end
end

endmodule