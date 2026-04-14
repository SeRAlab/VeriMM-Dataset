module top_module(
    input [15:0] float_a,
    input [15:0] float_b,
    output reg [15:0] float_out
);reg [31:0] a, b, product;
    reg [7:0] exp_a, exp_b, exp_out;
    reg [22:0] frac_a, frac_b, frac_out;
    reg sign_out;

    // Extracting sign, exponent and fraction from input a
    assign sign_out = float_a[15];
    assign exp_a = float_a[14:10];
    assign frac_a = {1'b1, float_a[9:0]};

    // Extracting sign, exponent and fraction from input b
    assign exp_b = float_b[14:10];
    assign frac_b = {1'b1, float_b[9:0]};

    // Calculating product of fractions
    always @* begin
        product = a * b;
        frac_out = product[22:1];
    end

    // Calculating exponent of output
    always @* begin
        exp_out = exp_a + exp_b - 15;
    end

    // Handling overflow and underflow
    always @* begin
        if (exp_out == 0) begin
            // Denormalized number
            frac_out = {1'b0, frac_out[22:1]};
        end else if (exp_out == 31) begin
            // Overflow
            exp_out = 30;
            frac_out = {1'b1, {22{1'b0}}};
        end else if (exp_out < 0) begin
            // Underflow
            exp_out = 0;
            frac_out = {1'b0, {22{1'b0}}};
        end
    end

    // Combining sign, exponent and fraction to form output
    always @* begin
        float_out[15] = sign_out;
        float_out[14:10] = exp_out;
        float_out[9:0] = frac_out[21:12];
    end

endmodule