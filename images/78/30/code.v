module top_module(
    input clk,
    input areset,  // async active-high reset to zero
    input load,
    input ena,
    input [3:0] data,
    input [15:0] in,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo,
    output wire [11:0] final_out);// 4-bit shift register with asynchronous reset, synchronous load, and enable
    reg [3:0] q;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q <= 4'b0;
        end else if (load) begin
            q <= data;
        end else if (ena) begin
            q <= {1'b0, q[3:1]};
        end
    end

    // 16-bit splitter using shift registers
    reg [7:0] shift_reg1, shift_reg2;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            shift_reg1 <= 8'b0;
            shift_reg2 <= 8'b0;
        end else begin
            shift_reg1 <= {in[15], shift_reg1[7:1]};
            shift_reg2 <= {in[7:0], shift_reg2[7:1]};
        end
    end
    assign out_hi = shift_reg1;
    assign out_lo = shift_reg2;

    // Adder module to add the outputs of the shift register and the splitter
    wire [11:0] adder_out;
    assign adder_out = {4'b0, q} + {8'b0, shift_reg1} + {8'b0, shift_reg2};
    assign final_out = adder_out;

endmodule