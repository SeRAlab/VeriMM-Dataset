module dram_cell(  
    input wire [3:0] data_in,  
    input wire control, // 1 for write, 0 for read  
    output reg [3:0] data_out  
);  
    reg [3:0] memory; // 4-bit memory storage  

    always @(posedge control) begin  
        if (control) begin  
            memory <= data_in; // Write operation  
        end  
    end  

    always @(negedge control) begin  
        data_out <= memory; // Read operation  
    end  
endmodule