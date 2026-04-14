module shift_register
    (
        input rst_n,
        input clk,
        input data_in,
        output reg [7:0] shift_out
    );

    reg [7:0] shift;

    always @(posedge clk) 
    begin
        if (!rst_n)
            shift <= 8'd0;
        else
            shift <= {shift[6:0], data_in};
    end

    always @(posedge clk)
    begin
        shift_out <= shift;
    end

endmodule