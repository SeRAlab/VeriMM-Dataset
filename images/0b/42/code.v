module register_file (  
    input wire clk,  
    input wire reset,  
    input wire [1:0] reg_addr,  
    input wire [31:0] write_data,  
    input wire read_enable,  
    input wire write_enable,  
    output reg [31:0] read_data  
);  
    reg [31:0] registers [3:0]; // 4 registers of 32 bits each  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            registers[0] <= 32'b0;  
            registers[1] <= 32'b0;  
            registers[2] <= 32'b0;  
            registers[3] <= 32'b0;  
        end else begin  
            if (write_enable) begin  
                registers[reg_addr] <= write_data;  
            end  
        end  
    end  

    always @(*) begin  
        if (read_enable) begin  
            read_data = registers[reg_addr];  
        end else begin  
            read_data = 32'b0;  
        end  
    end  
endmodule