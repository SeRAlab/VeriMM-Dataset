module top_module(
    input clk,
    input reset,
    input [31:2] pc_new,
    input take_branch,
    input pause_in,
    input [25:0] opcode25_0,
    input [1:0] pc_source,
    output reg [31:0] pc_out,
    output reg [31:0] pc_out_plus4
);// Define constants
    parameter PC_RESET = 32'h0000_0000;
    parameter FROM_INC4 = 2'b00;
    parameter FROM_OPCODE25_0 = 2'b01;
    parameter FROM_BRANCH = 2'b10;
    parameter FROM_LBRANCH = 2'b11;
    
    // Define signals
    reg [31:2] pc_next;
    reg [31:2] pc_reg;
    wire [31:2] pc_inc = pc_reg + 1;
    
    // Assign outputs
    assign pc_out = {pc_reg, 2'b00};
    assign pc_out_plus4 = {pc_inc, 2'b00};
    
    // Define always block for register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_reg <= PC_RESET;
        end else begin
            pc_reg <= pc_next;
        end
    end
    
    // Define always block for next PC value
    always @(*) begin
        case (pc_source)
            FROM_INC4: begin
                pc_next = pc_inc;
            end
            FROM_OPCODE25_0: begin
                pc_next = {pc_reg[31:28], opcode25_0};
            end
            FROM_BRANCH, FROM_LBRANCH: begin
                if (take_branch) begin
                    pc_next = pc_new;
                end else begin
                    pc_next = pc_inc;
                end
            end
            default: begin
                pc_next = pc_inc;
            end
        endcase
        
        if (pause_in) begin
            pc_next = pc_reg;
        end
    end
endmodule