module top_module(
    input clk,
    input reset,      // Asynchronous active-high reset
    input load,       // Active-high parallel load input
    input [3:0] load_value, // 4-bit load value
    output [3:0] q
);reg [3:0] q_reg1, q_reg2, q_reg3, q_reg4;
    reg [3:0] load_value_reg;
    reg [3:0] q_out; // Change from wire to reg

    assign q = q_out;

    // Pipeline stage 1
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q_reg1 <= 4'b1000;
        end else if (load) begin
            q_reg1 <= load_value;
        end else begin
            q_reg1 <= q_reg4;
        end
    end

    // Pipeline stage 2
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q_reg2 <= 4'b1000;
        end else if (load) begin
            q_reg2 <= load_value_reg;
        end else begin
            q_reg2 <= q_reg1;
        end
    end

    // Pipeline stage 3
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q_reg3 <= 4'b1000;
        end else if (load) begin
            q_reg3 <= load_value_reg;
        end else begin
            q_reg3 <= q_reg2;
        end
    end

    // Pipeline stage 4
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q_reg4 <= 4'b1000;
        end else if (load) begin
            q_reg4 <= load_value_reg;
        end else begin
            q_reg4 <= q_reg3 + 1;
        end
    end

    // Load value register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            load_value_reg <= 4'b0000;
        end else if (load) begin
            load_value_reg <= load_value;
        end
    end

    // Output register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q_out <= 4'b1000;
        end else if (load) begin
            q_out <= load_value_reg;
        end else begin
            q_out <= q_reg4;
        end
    end

endmodule