module turbo_encoder (  
    input clk,  
    input reset,  
    input [1:0] data_in,  
    input valid_in,  
    output reg [3:0] encoded_out,  
    output reg valid_out  
);  
    reg [1:0] state;  
    reg [1:0] interleaved_data;  
    reg [2:0] cnt;  

    // States  
    localparam IDLE = 2'b00,  
               ENCODE = 2'b01,  
               INTERLEAVE = 2'b10,  
               OUTPUT = 2'b11;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            encoded_out <= 4'b0000;  
            valid_out <= 0;  
            cnt <= 3'b000;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (valid_in) begin  
                        interleaved_data <= {data_in[1], data_in[0]};  
                        state <= ENCODE;  
                    end  
                end  
                ENCODE: begin  
                    encoded_out <= {interleaved_data[1] ^ interleaved_data[0], interleaved_data[1], interleaved_data[0], interleaved_data[1] & interleaved_data[0]};  
                    state <= INTERLEAVE;  
                end  
                INTERLEAVE: begin  
                    // Simple interleaver logic. Here, we're just swapping the bits.  
                    interleaved_data <= {interleaved_data[0], interleaved_data[1]};  
                    state <= OUTPUT;  
                end  
                OUTPUT: begin  
                    valid_out <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule