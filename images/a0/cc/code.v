module shift_register (
    input clk,
    input shift_enable,
    input load_enable,
    input [7:0] data_in,
    output [7:0] data_out );reg [7:0] register;

always @(posedge clk) begin
    if (load_enable)
        register <= data_in;
    else if (shift_enable)
        register <= {register[6:0], 1'b0};
end

assign data_out = register;

endmodule