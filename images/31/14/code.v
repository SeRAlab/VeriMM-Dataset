module SISO_Shift_Register(  
    input wire SI,  
    input wire CLK,  
    input wire RST,  
    output reg [4:0] SO  
);  
    always @(posedge CLK or posedge RST) begin  
        if (RST) begin  
            SO <= 5'b00000;  
        end else begin  
            SO <= {SO[3:0], SI};  
        end  
    end  
endmodule