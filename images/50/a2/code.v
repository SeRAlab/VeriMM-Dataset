module shift_reg8 (
    input clk,
    input rst,
    input si,
    output [7:0] po
);

    reg [7:0] sr;

    always @(posedge clk or posedge rst) begin
        if (rst)
            sr <= 8'b00000000;
        else
            sr <= {sr[6:0], si};
    end

    assign po = sr;

endmodule