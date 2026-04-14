module top_module(
        input wr_clk,
        input wr_en,
        input rst_d2,
        input rst_full_gen_i,
        input [4:0] v1_reg,
        input [3:0] v1_reg_0,
        input [0:0] I1,
        output reg full,
        output reg [0:0] E
    );// RAM to store the elements
    reg [15:0] ram [0:15];

    // Write pointer
    reg [3:0] wr_ptr = 0;

    // Read pointer
    reg [3:0] rd_ptr = 0;

    // Flag generator
    always @ (posedge wr_clk) begin
        if (rst_full_gen_i) begin
            full <= 0;
            E <= 1;
        end
        else begin
            if (v1_reg == 15) begin
                full <= 1;
                E <= 0;
            end
            else if (v1_reg == 0) begin
                full <= 0;
                E <= 1;
            end
            else begin
                full <= 0;
                E <= 0;
            end
        end
    end

    // Write operation
    always @ (posedge wr_clk) begin
        if (rst_d2) begin
            wr_ptr <= 0;
        end
        else if (wr_en) begin
            if (v1_reg != 15) begin
                ram[wr_ptr] <= 1'b1;
                wr_ptr <= wr_ptr + 1;
            end
        end
    end

    // Read operation
    always @ (posedge wr_clk) begin
        if (v1_reg_0 != 15) begin
            ram[rd_ptr] <= 1'b0;
            rd_ptr <= rd_ptr + 1;
        end
    end

endmodule