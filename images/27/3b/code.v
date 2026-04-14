module sram_cell (  
    input wire D,  
    input wire WE,  
    output reg Q  
);  
    always @ (posedge WE) begin  
        Q <= D;  
    end  
endmodule