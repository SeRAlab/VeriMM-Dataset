module top_module(
    input wire clk,
    input wire rst,
    input wire load_a,
    input wire load_b,
    input wire [11:0] Exp_X,
    input wire [11:0] Exp_Y,
    output wire [12:0] Exp_Add,
    output wire underflow_f
);// Declare wires and registers
    wire [12:0] Exp_Add_Verif;
    wire [12:0] U_Limit;
    wire underflow_exp_reg;
    wire carry_out;

    // Add the two exponents and store the result in Exp_Add_Verif
    assign {carry_out, Exp_Add_Verif} = Exp_X + Exp_Y;  // Simplified addition

    // Register Exp_Add_Verif using a 13-bit register called ExpAdd_Register
    reg [12:0] Exp_Add_reg;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Exp_Add_reg <= 13'b0;
        end else if (load_a) begin
            Exp_Add_reg <= Exp_Add_Verif;
        end
    end
    assign Exp_Add = Exp_Add_reg;

    // Set the limit value based on some condition (assuming the condition for U_Limit)
    assign U_Limit = (12 == 8) ? 13'd127 : 13'd1023; // Check your condition accordingly

    // Set the underflow flag if the sum exceeds the limit
    assign underflow_exp_reg = (Exp_Add > U_Limit) ? 1'b1 : 1'b0;

    // Register the underflow flag using a 1-bit register called ExpUnderflow_Register
    reg underflow_reg;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            underflow_reg <= 1'b0;
        end else if (load_b) begin
            underflow_reg <= underflow_exp_reg;
        end
    end
    assign underflow_f = underflow_reg;

endmodule