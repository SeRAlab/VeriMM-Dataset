module ARQ_System(  
    input clk,  
    input rst,  
    input [7:0] data_in,  
    input error_in,  
    output reg [7:0] data_out,  
    output reg ack  
);  
    reg [7:0] data_reg;  
    reg error_detected;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            data_reg <= 8'b0;  
            error_detected <= 1'b0;  
            ack <= 1'b0;  
        end else begin  
            data_reg <= data_in;  
            error_detected <= error_in;  
            if (!error_detected) begin  
                data_out <= data_reg;  
                ack <= 1'b1;  
            end else begin  
                ack <= 1'b0;  
            end  
        end  
    end  
endmodule