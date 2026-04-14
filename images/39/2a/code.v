module nvme_command_register(  
    input clk,  
    input rst,  
    input [15:0] command_in,  
    input command_valid,  
    output reg [15:0] command_out,  
    output reg ready  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            command_out <= 16'b0;  
            ready <= 1'b0;  
        end else if (command_valid) begin  
            command_out <= command_in;  
            ready <= 1'b1;  
        end else begin  
            ready <= 1'b0;  
        end  
    end  
endmodule