module odd_parity_generator (
    input [3:0] data,
    output reg parity
);
    always @* begin
        parity = ~(^data); // Generate odd parity
    end
endmodule