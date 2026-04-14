module turbo_encoder(  
    input wire clk,  
    input wire rst,  
    input wire [7:0] input_data,  
    input wire valid,  
    output reg [7:0] encoded_data1,  
    output reg [7:0] encoded_data2,  
    output reg valid_out  
);  

    reg [7:0] interleaved_data;  
    reg [2:0] state;  
    reg [2:0] next_state;  

    // Simple convolutional encoding logic (rate 1/2)  
    function [7:0] conv_encode;  
        input [7:0] data;  
        begin  
            conv_encode[0] = data[0] ^ data[1];  
            conv_encode[1] = data[1] ^ data[2];  
            conv_encode[2] = data[2] ^ data[3];  
            conv_encode[3] = data[3] ^ data[4];  
            conv_encode[4] = data[4] ^ data[5];  
            conv_encode[5] = data[5] ^ data[6];  
            conv_encode[6] = data[6] ^ data[7];  
            conv_encode[7] = data[7];  
        end  
    endfunction  

    // Simple interleave function  
    function [7:0] interleave;  
        input [7:0] data;  
        begin  
            interleave[0] = data[0];  
            interleave[1] = data[2];  
            interleave[2] = data[4];  
            interleave[3] = data[6];  
            interleave[4] = data[1];  
            interleave[5] = data[3];  
            interleave[6] = data[5];  
            interleave[7] = data[7];  
        end  
    endfunction  

    // State Machine for the encoder  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= 0;  
            valid_out <= 0;  
        end else begin  
            case (state)  
                0: begin  
                    if (valid) begin  
                        interleaved_data <= interleave(input_data);  
                        encoded_data1 <= conv_encode(input_data);  
                        state <= 1;  
                    end  
                end  
                1: begin  
                    encoded_data2 <= conv_encode(interleaved_data);  
                    valid_out <= 1;  
                    state <= 0;  
                end  
            endcase  
        end  
    end  
endmodule