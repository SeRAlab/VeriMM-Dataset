module my_module(
    input clk,
    input [3:0] data_in,
    output reg data_out
);

    reg [3:0] data_reg;
    wire [3:0] data_wire;

    always @(posedge clk) begin
        data_reg <= data_in;
    end

    assign data_wire = data_reg;

    always @(*) begin
        if (data_wire <= 5) begin
            data_out = 1;
        end else begin
            data_out = 0;
        end
    end

endmodule