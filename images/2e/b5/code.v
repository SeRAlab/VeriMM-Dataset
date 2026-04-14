module sram_cell(  
    input wire [7:0] data,  
    input wire we,  
    output reg [7:0] q  
);  
    always @(posedge we) begin  
        q <= data;  
    end  
endmodule