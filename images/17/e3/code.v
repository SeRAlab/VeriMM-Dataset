module viterbi_decoder (  
    input wire clk,  
    input wire reset,  
    input wire [1:0] received_bits,  
    output reg [3:0] decoded_bits,  
    output reg valid  
);  
    reg [3:0] state;  
    reg [3:0] next_state;  
    reg [1:0] path_metric [0:3];  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 0;  
            valid <= 0;  
            decoded_bits <= 0;  
            for (i = 0; i < 4; i = i + 1)  
                path_metric[i] <= 0;  
        end else begin  
            state <= next_state;  
            valid <= 1;  
        end  
    end  

    always @* begin  
        case (state)  
            0: begin  
                if (received_bits == 2'b00) begin  
                    next_state = 0;  
                    path_metric[0] = path_metric[0] + 1;  
                end else if (received_bits == 2'b01) begin  
                    next_state = 1;  
                    path_metric[1] = path_metric[1] + 1;  
                end else if (received_bits == 2'b10) begin  
                    next_state = 2;  
                    path_metric[2] = path_metric[2] + 1;  
                end else begin  
                    next_state = 3;  
                    path_metric[3] = path_metric[3] + 1;  
                end  
            end  
            1: begin  
                // handle state 1 logic  
            end  
            2: begin  
                // handle state 2 logic  
            end  
            3: begin  
                // handle state 3 logic  
            end  
            default: next_state = 0;  
        endcase  
        decoded_bits = state;  
    end  
endmodule