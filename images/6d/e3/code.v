module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);reg [99:0] shift_reg [2:0];
reg [1:0] ena_reg;
reg load_reg;

integer i;

always @(posedge clk) begin
    // Pipeline stage 1
    if (load) begin
        load_reg <= 1'b1;
        ena_reg <= 2'b00;
    end else begin
        load_reg <= 1'b0;
        ena_reg <= ena;
    end
    
    // Pipeline stage 2
    if (load_reg) begin
        for (i = 0; i < 3; i = i + 1) begin
            shift_reg[i] <= data;
        end
    end else begin
        shift_reg[0] <= {shift_reg[0][98:0], shift_reg[1][99]}; // corrected order
        shift_reg[1] <= {shift_reg[1][98:0], shift_reg[2][99]}; // corrected order
        shift_reg[2] <= {shift_reg[2][98:0], shift_reg[0][99]}; // corrected order
    end
    
    // Pipeline stage 3
    case (ena_reg)
        2'b01: begin
            q <= {shift_reg[2][1:0], shift_reg[0][99:2]};
        end
        2'b10: begin
            q <= {shift_reg[1][99:2], shift_reg[0][1:0]};
        end
        default: begin
            q <= shift_reg[0];
        end
    endcase
end

endmodule