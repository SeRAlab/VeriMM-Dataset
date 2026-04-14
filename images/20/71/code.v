module nvme_command_register (  
    input wire clk,  
    input wire rst,  
    input wire [3:0] cmd_type,  // Command type: 00 - read, 01 - write  
    input wire [3:0] address,  
    input wire cmd_valid,  
    output reg [3:0] stored_cmd_type,  
    output reg [3:0] stored_address,  
    output reg cmd_ready  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            stored_cmd_type <= 4'b0000;  
            stored_address <= 4'b0000;  
            cmd_ready <= 1'b0;  
        end else if (cmd_valid) begin  
            stored_cmd_type <= cmd_type;  
            stored_address <= address;  
            cmd_ready <= 1'b1;  
        end  
    end  
endmodule