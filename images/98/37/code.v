module mux_2to1_8bit(
    input               clk     ,
    input               rst_n   ,
    input       [7:0]   in0     ,
    input       [7:0]   in1     ,
    input               sel     ,

    output  reg [7:0]   out     
);

    // 2-to-1 multiplexer operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out <= 0;
        end else begin
            out <= sel ? in1 : in0;
        end
    end

endmodule