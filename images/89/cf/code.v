module shift_register(
    input  clk,
    input  load,
    input  [3:0] data_in,
    output [3:0] data_out
);

reg [3:0] register;

always @(posedge clk) begin
    if (load) begin
        register <= data_in;
    end else begin
        register <= {1'b0, register[3:1]};
    end
end

assign data_out = register;

endmodule