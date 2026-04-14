module top_module(DigitalLDir, DigitalRDir, reset_n, outputs);input DigitalLDir;
    input DigitalRDir;
    input reset_n;
    output [3:0]outputs;
    
    reg [3:0]outputs_reg;
    
    always @(*) begin
        if (reset_n == 1'b0) begin
            outputs_reg <= 4'b0000;
        end else begin
            case ({DigitalLDir, DigitalRDir})
                2'b11: outputs_reg <= 4'b1111;
                2'b10: outputs_reg <= 4'b1100;
                2'b01: outputs_reg <= 4'b0011;
                default: outputs_reg <= 4'b0000;
            endcase
        end
    end
    
    assign outputs = outputs_reg;
    
endmodule