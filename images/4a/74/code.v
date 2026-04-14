module top_module(clk, rst, en, out);input clk, rst, en;
    output [3:0] out;
    
    reg [3:0] count;
    
    always @(posedge clk or posedge rst)
    begin
        if (rst)
            count <= 4'd0;
        else if (en)
            count <= count + 1;
    end
    
    assign out = count;
endmodule