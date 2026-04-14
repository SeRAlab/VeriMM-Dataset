module crc_generator(  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire [15:0] data_in,  
    input wire [15:0] polynomial,  
    output reg [15:0] crc_out,  
    output reg ready  
);  
    reg [15:0] shift_reg;  
    reg [4:0] bit_count;  
    reg doing_crc;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            crc_out <= 16'd0;  
            shift_reg <= 16'd0;  
            bit_count <= 5'd0;  
            ready <= 1'b0;  
            doing_crc <= 1'b0;  
        end else if (start && !doing_crc) begin  
            shift_reg <= data_in;  
            crc_out <= 16'd0;  
            bit_count <= 5'd0;  
            doing_crc <= 1'b1;  
            ready <= 1'b0;  
        end else if (doing_crc) begin  
            if (bit_count < 16) begin  
                if (shift_reg[15] ^ crc_out[15]) begin  
                    crc_out <= (crc_out << 1) ^ polynomial;  
                end else begin  
                    crc_out <= crc_out << 1;  
                end  
                crc_out[0] <= shift_reg[14];  
                shift_reg <= shift_reg << 1;  
                bit_count <= bit_count + 1;  
            end else begin  
                doing_crc <= 1'b0;  
                ready <= 1'b1;  
            end  
        end  
    end  
endmodule