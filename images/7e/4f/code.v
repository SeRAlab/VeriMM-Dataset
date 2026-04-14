module top_module(
    input clk, // clock input
    input rst, // reset input
    input load_b_i, // load input
    input signed [25:0] Data_A_i, // input A
    input signed [25:0] Data_B_i, // input B
    output signed [51:0] sgf_result_o // output result
);reg signed [25:0] reg_Data_B_i; // register to store input B
    reg signed [51:0] reg_sgf_result_o; // register to store result

    always @(posedge clk) begin
        if (rst) begin
            reg_Data_B_i <= 0;
            reg_sgf_result_o <= 0;
        end else begin
            if (load_b_i) begin
                reg_Data_B_i <= Data_B_i;
            end
            reg_sgf_result_o <= $signed(Data_A_i) * $signed(reg_Data_B_i);
        end
    end

    assign sgf_result_o = reg_sgf_result_o;

endmodule