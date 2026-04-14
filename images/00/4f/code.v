module dram_cell(  
    input wire D,  
    input wire WL,  
    input wire clk,  
    output reg Q  
);  
    reg stored_data;  
    always @(posedge clk) begin  
        if (WL) begin  
            stored_data <= D;  
        end  
        Q <= stored_data;  
    end  
endmodule