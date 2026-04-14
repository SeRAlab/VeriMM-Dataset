module odd_parity_generator (
    input [7:0] data,
    output reg parity);

    always @* begin
        parity = ~^data;
    end
endmodule