module register_file(  
    input wire clk,  
    input wire we,  
    input wire [1:0] write_addr,  
    input wire [1:0] read_addr,  
    input wire [31:0] write_data,  
    output reg [31:0] read_data  
);  
    reg [31:0] registers [3:0]; // 4 registers of 32-bit each  

    always @(posedge clk) begin  
        if (we) begin  
            registers[write_addr] <= write_data;  
        end  
    end  

    always @(*) begin  
        read_data = registers[read_addr];  
    end  
endmodule