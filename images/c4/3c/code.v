module ripple_addsub (
    input [7:0] A,
    input [7:0] B,
    input SUB,
    input CLK,
    output reg [7:0] SUM,
    output reg CARRY_OUT
);

    reg [7:0] temp_sum;
    reg carry_in;

    always @(posedge CLK) begin
        if(SUB) begin
            temp_sum <= A - B - carry_in;
            CARRY_OUT <= ~((~A[7] & B[7]) | (~B[7] & temp_sum[7]) | (temp_sum[7] & ~A[7]));
        end else begin
            temp_sum <= A + B + carry_in;
            CARRY_OUT <= (temp_sum[8] == 1);
        end
        SUM <= temp_sum[7:0];
        carry_in <= CARRY_OUT;
    end

endmodule