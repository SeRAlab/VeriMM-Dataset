module gray_code_counter(
    input clk,
    input rst_n,
    output reg [1:0] q
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 2'b00;
        else
            case (q)
                2'b00: q <= 2'b01;
                2'b01: q <= 2'b11;
                2'b11: q <= 2'b10;
                2'b10: q <= 2'b00;
                default: q <= 2'b00;
            endcase
    end
    
endmodule