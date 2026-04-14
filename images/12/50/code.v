module dram_cell(  
    input wire D,  
    input wire WL,  
    input wire RST,  
    output reg Q  
);  
    always @(posedge WL or posedge RST) begin  
        if (RST) begin  
            Q <= 0;  
        end else begin  
            Q <= D;  
        end  
    end  
endmodule