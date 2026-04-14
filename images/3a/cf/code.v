module ring_counter(  
    input clk,  
    input rst,  
    output reg [4:0] out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            out <= 5'b00001;  
        else  
            out <= {out[3:0], out[4]};  
    end  
endmodule