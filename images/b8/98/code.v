module shift_register(
    input               clk         ,
    input               reset       ,
    input               enable      ,
    input               load        ,
    input               serial_in   ,
    input       [7:0]   parallel_in ,
    output  reg [7:0]   parallel_out
);

    always @(posedge clk) begin
        if (reset) begin
            parallel_out <= 8'b00000000;
        end else if (load) begin
            parallel_out <= parallel_in;
        end else if (enable) begin
            parallel_out <= {parallel_out[6:0], serial_in};
        end
    end

endmodule