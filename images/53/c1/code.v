module clk_divider(
    input       clk_in,
    input       rst_n,
    output  reg clk_out
);

    reg [1:0] count;

    always @(posedge clk_in or negedge rst_n) begin
        if(!rst_n) begin
            count <= 2'b00;
            clk_out <= 1'b0;
        end
        else begin
            count <= count + 1;
            if(count == 2'b11) begin
                clk_out <= ~clk_out;
                count <= 2'b00;
            end
        end
    end

endmodule