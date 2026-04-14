module dram_cell (  
    input wire din,  
    input wire we,  
    output reg dout  
);  
    always @(posedge we) begin  
        dout <= din;  
    end  
endmodule