module shift_register (  
    input wire clk,  
    input wire [1:0] data,  
    output reg [1:0] q  
);  
    always @(posedge clk) begin  
        q <= data;  
    end  
endmodule