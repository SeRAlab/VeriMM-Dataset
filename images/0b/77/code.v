module SIPO_Shift_Register (  
    input wire clk,  
    input wire rst,  
    input wire SI,  
    output reg [3:0] PO  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            PO <= 4'b0000;  
        else  
            PO <= {PO[2:0], SI};  
    end  
endmodule