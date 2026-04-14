module dram_cell (  
    input wire d,  
    input wire wl,  
    input wire reset,  
    output reg bl  
);  
    reg stored_data;  
  
    always @(posedge wl or posedge reset) begin  
        if (reset)  
            stored_data <= 0;  
        else  
            stored_data <= d;  
    end  
  
    always @(negedge wl) begin  
        bl <= stored_data;  
    end  
endmodule