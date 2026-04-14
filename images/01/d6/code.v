module RLE_Encoder (  
    input clk,  
    input rst,  
    input bit_in,  
    output reg [7:0] count,  
    output reg value_out,  
    output reg valid  
);  
    reg [7:0] rle_count;  
    reg last_bit;  
    reg [3:0] state;  

    parameter IDLE = 0, COUNT = 1, OUTPUT = 2;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            rle_count <= 0;  
            last_bit <= 0;  
            state <= IDLE;  
            valid <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    rle_count <= 0;  
                    last_bit <= bit_in;  
                    state <= COUNT;  
                end  
                COUNT: begin  
                    if (bit_in == last_bit) begin  
                        rle_count <= rle_count + 1;  
                    end else begin  
                        count <= rle_count;  
                        value_out <= last_bit;  
                        valid <= 1;  
                        last_bit <= bit_in;  
                        rle_count <= 1;  
                        state <= OUTPUT;  
                    end  
                end  
                OUTPUT: begin  
                    if (valid) begin  
                        valid <= 0;  
                        state <= COUNT;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule