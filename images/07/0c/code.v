module sd_card_command_decoder (  
    input wire clk,  
    input wire rst_n,  
    input wire [3:0] command,  
    output reg [1:0] response  
);  
    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n)  
            response <= 2'b00;  
        else begin  
            case (command)  
                4'b0000: response <= 2'b00;  
                4'b0001: response <= 2'b01;  
                4'b0010: response <= 2'b10;  
                4'b0011: response <= 2'b11;  
                default: response <= 2'b00;  
            endcase  
        end  
    end  
endmodule