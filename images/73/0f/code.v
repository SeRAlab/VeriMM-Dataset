module top_module(
    input clk,
    input areset,  // async active-high reset to zero
    input load,
    input ena,
    input a, 
    input b,
    input c,
    input d,
    output wire out_shift_register,
    output wire out_multiplexer,
    output reg [3:0] q,
    output reg [3:0] final_output
);// XOR gate
    wire xor_out;
    assign xor_out = a ^ b ^ c ^ d;
    
    // 4-bit shift register with asynchronous reset, synchronous load, and enable
    reg [3:0] shift_reg;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            shift_reg <= 4'b0;
        end else if (ena) begin
            shift_reg <= {shift_reg[2:0], xor_out};
        end else if (load) begin
            shift_reg <= {d, c, b, a};
        end
    end
    assign out_shift_register = shift_reg[0];
    
    // 4-to-1 multiplexer
    wire [3:0] mux_out;
    assign mux_out = (q == 4'b00) ? a :
                     (q == 4'b01) ? b :
                     (q == 4'b10) ? c :
                                    d ;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q <= 4'b0;
        end else if (ena) begin
            q <= {q[2:0], q[3]};
        end else if (load) begin
            q <= shift_reg;
        end
    end
    assign out_multiplexer = mux_out;
    
    // functional module
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            final_output <= 4'b0;
        end else if (ena) begin
            final_output <= mux_out ^ xor_out;
        end else if (load) begin
            final_output <= 4'b0;
        end
    end
    
endmodule