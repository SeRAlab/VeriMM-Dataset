module shift_register(
    input wire clk,
    input wire load,
    input wire [7:0] data,
    output wire q
);

reg [7:0] register;

always @(posedge clk) begin
    if (load)
        register <= data;
    else
        register <= register >> 1;
end

assign q = register[0];

endmodule