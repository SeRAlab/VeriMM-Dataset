module rle_encoder (  
    input clk,  
    input rst,  
    input [7:0] data_in,  
    output reg [3:0] run_length,  
    output reg data_out  
);  
    reg [7:0] count;  
    reg [7:0] last_data;  
    reg [2:0] state;  
    parameter IDLE = 3'b000, COUNT = 3'b001, OUTPUT = 3'b010;  
    
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            count <= 0;  
            run_length <= 0;  
            data_out <= 0;  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (data_in != last_data) begin  
                        last_data <= data_in;  
                        state <= COUNT;  
                        count <= 1;  
                    end else begin  
                        count <= count + 1;  
                    end  
                end  
                COUNT: begin  
                    if (count < 8) begin  
                        state <= COUNT;  
                        count <= count + 1;  
                    end else begin  
                        run_length <= count;  
                        data_out <= last_data;  
                        state <= OUTPUT;  
                    end  
                end  
                OUTPUT: begin  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule