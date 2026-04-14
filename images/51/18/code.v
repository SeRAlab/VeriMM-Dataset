module DownCounter_3bit(
   input                clk,
   input                rst,
 
   output reg [2:0]     count  
);
    always@(posedge clk) begin
        if(rst) 
            count <= 3'b111; // Reset counter to 7
        else 
            count <= count - 1;
    end
endmodule