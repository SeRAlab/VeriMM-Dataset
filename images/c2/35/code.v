module shift_register(clk, load, in, shift, out);
    input clk, load, shift;
    input [3:0] in;
    output [3:0] out;
    reg [3:0] reg_out;
    
    always @(posedge clk) begin
        if (load) begin
            reg_out <= in;
        end else if (shift) begin
            reg_out <= {reg_out[2:0], 1'b0};
        end
    end
    
    assign out = reg_out;
endmodule