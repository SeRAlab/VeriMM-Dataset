module audio_compression(input clk,  
                         input reset,  
                         input [15:0] audio_sample,  
                         input valid_in,  
                         output reg [15:0] compressed_data,  
                         output reg valid_out);  
  
    reg [15:0] current_sample;  
    reg [3:0] count;  
    reg [15:0] compressed_buffer;  
    reg [2:0] state;  
  
    localparam IDLE = 3'b000,  
               COMPRESS = 3'b001,  
               OUTPUT = 3'b010;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            valid_out <= 0;  
            current_sample <= 0;  
            count <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (valid_in) begin  
                        current_sample <= audio_sample;  
                        count <= 1;  
                        state <= COMPRESS;  
                    end  
                end  
                COMPRESS: begin  
                    if (valid_in && audio_sample == current_sample) begin  
                        count <= count + 1;  
                    end else begin  
                        compressed_buffer <= {count, current_sample};  
                        compressed_data <= compressed_buffer;  
                        valid_out <= 1;  
                        state <= OUTPUT;  
                    end  
                end  
                OUTPUT: begin  
                    valid_out <= 0;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule