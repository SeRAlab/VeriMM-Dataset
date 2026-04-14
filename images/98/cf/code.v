module top_module(
    output logic signed [11:0] dst, // Change from wire to logic
    input  logic signed [11:0] src
);logic signed [11:0] temp;
    always_comb begin
        temp = src + 4;
        if (temp < -2048)
            dst = -2048;
        else if (temp > 2047)
            dst = 2047;
        else
            dst = temp;
    end

endmodule