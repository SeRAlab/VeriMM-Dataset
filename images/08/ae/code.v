module dram_cell (input [15:0] data_in,  
                  input [3:0] addr,  
                  input read,  
                  input write,  
                  output reg [15:0] data_out);  
                  
    reg [15:0] memory [15:0];  // 16 16-bit memory cells  
                  
    always @(*) begin  
        if (write) begin  
            memory[addr] <= data_in;  
        end  
    end  

    always @(*) begin  
        if (read) begin  
            data_out <= memory[addr];  
        end  
    end  
endmodule