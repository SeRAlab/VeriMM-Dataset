module NVMeController(  
    input wire clk,  
    input wire load_cmd,  
    input wire cmd_complete,  
    input wire [3:0] new_cmd,  
    output reg [3:0] cmd_reg,  
    output reg [3:0] status_reg,  
    output reg cmd_done  
);  

    always @(posedge clk) begin  
        if (load_cmd)  
            cmd_reg <= new_cmd;  
    end  

    always @(posedge clk) begin  
        if (cmd_complete) begin  
            status_reg <= 4'b0001; // Command completed  
            cmd_done <= 1;  
        end else begin  
            cmd_done <= 0;  
        end  
    end  
endmodule