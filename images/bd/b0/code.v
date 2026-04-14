module top_module(/*AUTOARG*/
    // Ports
    input clk,
    input rst,
    input load,
    input [3:0] in,
    output [3:0] out,
    input enable
);reg [3:0] register;

    always @(posedge clk) begin
        if (rst) begin
            register <= 4'b0;
        end else if (enable) begin
            if (load) begin
                register <= in;
            end else begin
                register <= {register[2:0], register[3]};
            end
        end
    end

    assign out = register;

endmodule