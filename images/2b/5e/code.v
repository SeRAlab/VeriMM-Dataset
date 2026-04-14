module sram_cell (  
    input wire [7:0] data_in,  
    input wire we,  
    output reg [7:0] data_out  
);  
    // Internal storage for the SRAM cell  
    reg [7:0] storage;  
  
    always @(we or data_in) begin  
        if (we) begin  
            storage <= data_in;  // Write data to storage  
        end  
    end  
  
    always @(*) begin  
        data_out = storage;  // Output stored data  
    end  
endmodule