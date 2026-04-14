module dram_cell (  
    input [3:0] DIN,  
    input RW,  
    input CLK,  
    output reg [3:0] DOUT  
);  
    reg [3:0] storage;  

    always @(posedge CLK) begin  
        if (RW) begin  
            storage <= DIN;  
        end else begin  
            DOUT <= storage;  
        end  
    end  
endmodule