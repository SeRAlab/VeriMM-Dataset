module binary_counter(
    input               clk     ,
    input               rst_n   ,

    output  reg [3:0]   count
);

    // Binary counter operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end

endmodule