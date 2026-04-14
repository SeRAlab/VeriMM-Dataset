module instruction_pipeline (
    input clk,
    input rst,
    input [4:0] instruction_in,
    output reg [4:0] if_stage,
    output reg [4:0] id_stage,
    output reg [4:0] ex_stage
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            if_stage <= 5'b00000;
            id_stage <= 5'b00000;
            ex_stage <= 5'b00000;
        end else begin
            ex_stage <= id_stage;        // Pass ID stage instruction to EX stage
            id_stage <= if_stage;        // Pass IF stage instruction to ID stage
            if_stage <= instruction_in;  // Load new instruction into IF stage
        end
    end
endmodule