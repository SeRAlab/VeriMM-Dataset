module deserializer (  
    input wire clk,  
    input wire reset,  
    input wire serial_in,  
    output reg [7:0] parallel_out,  
    output reg valid  
);  
    reg [2:0] bit_count;  
    reg [7:0] shift_reg;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            bit_count <= 3'b0;  
            shift_reg <= 8'b0;  
            valid <= 1'b0;  
        end else begin  
            if (bit_count < 3'd8) begin  
                shift_reg <= {shift_reg[6:0], serial_in};  
                bit_count <= bit_count + 1;  
                valid <= 1'b0;  
            end  
            if (bit_count == 3'd7) begin  
                parallel_out <= shift_reg;  
                valid <= 1'b1;  
                bit_count <= 3'b0;  
            end  
        end  
    end  
endmodule