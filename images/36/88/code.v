module SRAM_Cell (  
    input wire D,  
    input wire WE,  
    output reg Q,  
    output wire Qn  
);  
    assign Qn = ~Q;  

    always @(WE or D) begin  
        if (WE)  
            Q <= D;  
    end  
endmodule