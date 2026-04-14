module turbo_encoder (  
    input clk,  
    input reset,  
    input [3:0] data_in,  
    output reg [5:0] encoded_out  
);  
    reg [3:0] interleaved_data;  
    reg [2:0] state;  
    parameter IDLE = 3'b000, ENCODE1 = 3'b001, ENCODE2 = 3'b010;  
  
    // Simple polynomial for convolutional encoding  
    function [1:0] convolutional_encode;  
        input [3:0] data;  
        begin  
            convolutional_encode[0] = data[0] ^ data[1] ^ data[3];  
            convolutional_encode[1] = data[1] ^ data[2] ^ data[3];  
        end  
    endfunction  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            encoded_out <= 6'b0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    interleaved_data <= {data_in[2:0], data_in[3]}; // Simple interleaving  
                    state <= ENCODE1;  
                end  
                ENCODE1: begin  
                    encoded_out[5:4] <= convolutional_encode(data_in);  
                    state <= ENCODE2;  
                end  
                ENCODE2: begin  
                    encoded_out[3:2] <= convolutional_encode(interleaved_data);  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule