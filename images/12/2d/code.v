module sram_cell (  
    input wire D,  
    input wire WL,  
    input wire CE,  
    output reg Q,  
    output wire Qn  
);  
    assign Qn = ~Q;  

    always @(posedge WL or negedge CE) begin  
        if (!CE)  
            Q <= Q;  
        else  
            Q <= D;  
    end  
endmodule