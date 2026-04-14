module Counter_4(
   input             clk,
   input             rst,
   input             en,
   output reg [3:0]  count  
);
    always@(posedge clk or posedge rst) begin
        if(rst) count <= 4'b0000; // Reset the counter to 0
        else if(en) count <= count + 1;
    end
endmodule