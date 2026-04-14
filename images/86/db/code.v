module even_parity_checker (
    input [7:0] data,
    output reg parity_error);

    always @* begin
        parity_error = ^data;
    end
endmodule