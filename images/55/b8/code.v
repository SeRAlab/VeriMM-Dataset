module top_module(clk, reset, data_in, enable, data_out);input clk, reset, enable;
    input [31:0] data_in;
    output [31:0] data_out;
    reg [31:0] reg_out;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_out <= 0;
        end else if (enable) begin
            reg_out <= data_in;
        end
    end
    
    assign data_out = reg_out;
endmodule