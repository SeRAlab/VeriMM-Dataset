module top_module(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q_reg,
    output [2:0] q_count,
    output [7:0] final_output
);reg [7:0] shift_reg;
    reg [2:0] count;
    
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'b0;
            count <= 3'b0;
        end else begin
            shift_reg <= {shift_reg[6:0], d};
            count <= count + {1'b0, d[7], d[6], d[5], d[4], d[3], d[2], d[1], d[0]};
        end
    end
    
    assign q_reg = shift_reg;
    assign q_count = count;
    
    assign final_output = q_reg & {q_count[2], q_count[1], q_count[0]};
    
endmodule