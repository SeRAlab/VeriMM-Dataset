module top_module(
        input  clk_i,
        input  rst_i,
        input  ai,
        input  bi,
        output yo
    );reg test;
    always @ (posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            test <= 1'b0;
        end else begin
            if (ai|bi) begin
                test <= 1'b1;
            end else begin
                test <= 1'b0;
            end
        end
    end
   assign yo = test;
endmodule