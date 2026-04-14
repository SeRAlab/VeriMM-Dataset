module top_module(input [3:0] input_signal, output [1:0] output_signal);reg [1:0] output_reg;
    
    always @(*) begin
        if (input_signal < 6) begin
            output_reg = input_signal >> 1;
        end else begin
            output_reg = input_signal - 4;
        end
    end
    
    assign output_signal = output_reg;
endmodule