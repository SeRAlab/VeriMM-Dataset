module Johnson_Counter_3bit(
   input                clk,
   input                rst,
 
   output reg  [2:0]    Q  
);
    always @(posedge clk or posedge rst) begin
        if(rst)
            Q <= 3'b000;
        else
            Q <= {~Q[2], Q[2:1]};
    end
endmodule