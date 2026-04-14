module SRAMCell(  
    input wire [15:0] data_in,  
    input wire we,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory;  

    always @(posedge we) begin  
        memory <= data_in;  
    end  

    always @(negedge we) begin  
        data_out <= memory;  
    end  
endmodule