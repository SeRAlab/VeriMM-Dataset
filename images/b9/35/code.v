module register_8bit(
    input       clk,
    input       load,
    input [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if(load) begin
            q <= d;
        end
    end

endmodule