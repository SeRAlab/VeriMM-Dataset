module lzw_compressor (  
    input clk,  
    input reset,  
    input [7:0] data_in,  
    output reg [15:0] compressed_out,  
    output reg valid_out  
);  
    reg [7:0] dictionary [0:255];  
    reg [7:0] current_pattern;  
    reg [7:0] next_pattern;  
    reg [7:0] index;  
    reg [7:0] code;  
    reg [3:0] state;  

    parameter IDLE = 4'b0000, READ = 4'b0001, COMPRESS = 4'b0010, OUTPUT = 4'b0011;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            valid_out <= 0;  
            index <= 0;  
            compressed_out <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    state <= READ;  
                end  
                READ: begin  
                    current_pattern <= data_in;  
                    state <= COMPRESS;  
                end  
                COMPRESS: begin  
                    // Simple compression logic (placeholder)  
                    if (index < 255) begin  
                        dictionary[index] <= current_pattern;  
                        code <= index;  
                        index <= index + 1;  
                    end  
                    state <= OUTPUT;  
                end  
                OUTPUT: begin  
                    compressed_out <= {code, 8'h00};  
                    valid_out <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule