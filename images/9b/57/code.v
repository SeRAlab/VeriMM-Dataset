module JohnsonCounter_4bit(
   input                clk,
   input                rst_n,
 
   output reg [3:0]     count  
);
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) 
            count <= 4'b0000; // Reset counter to 0
        else 
            count <= {count[2:0], ~count[3]};
    end
endmodule