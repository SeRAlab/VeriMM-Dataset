module deadbeat_controller (  
    input clk,  
    input [3:0] in,  
    output reg [3:0] out  
);  

always @(posedge clk) begin  
    out <= in * 2;  
end  

endmodule