module top_module(clk, rst, load_a_i, load_b_i, add_subt_i, Data_X_i, Data_Y_i, DMP_o, DmP_o, zero_flag_o, real_op_o, sign_final_result_o);input clk;
    input rst;
    input load_a_i;
    input load_b_i;
    input add_subt_i;
    input [31:0] Data_X_i;
    input [31:0] Data_Y_i;
    output [30:0] DMP_o;
    output [30:0] DmP_o;
    output zero_flag_o;
    output real_op_o;
    output sign_final_result_o;

    reg [31:0] X; // Changed wire to reg for storage
    reg [31:0] Y; // Changed wire to reg for storage
    wire [31:0] result;
    wire [31:0] twos_complement;
    wire carry;
    wire borrow;
    wire zero_flag;
    wire real_op;
    wire sign_final_result;

    assign DMP_o = result[30:0];
    assign DmP_o = result[29:0];
    assign zero_flag_o = zero_flag;
    assign real_op_o = real_op;
    assign sign_final_result_o = sign_final_result;

    // Implementing the functionality of the registers directly
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            X <= 0;
            Y <= 0;
        end else begin
            if (load_a_i) begin
                X <= Data_X_i;
            end
            if (load_b_i) begin
                Y <= Data_Y_i;
            end
        end
    end

    assign twos_complement = ~Y + 1;

    assign borrow = (add_subt_i == 1) ? (X[0] < Y[0]) : (X[0] > twos_complement[0]);
    assign carry = (add_subt_i == 0) ? (X[0] < Y[0]) : (X[0] > twos_complement[0]);

    assign real_op = add_subt_i;
    assign sign_final_result = (result[31] == 1);
    assign zero_flag = (result == 0);
    assign result = (add_subt_i == 1) ? (X + Y) : (X + twos_complement);

endmodule