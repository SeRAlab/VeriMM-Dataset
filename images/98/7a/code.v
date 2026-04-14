module top_module(
    input CLK,
    input RST,
    input LD,
    input [3:0] D,
    output reg [3:0] OUT
);reg [3:0] reg_data;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            reg_data <= 4'b0;
        end
        else if (LD) begin
            reg_data <= D;
        end
        else begin
            reg_data <= {reg_data[2:0], 1'b0};
        end
    end

    assign OUT = reg_data;

endmodule