module top_module(
    input clk,
    input Reset,
    input Write_Reg,
    input Mem_Write,
    input [15:0] offset,
    input [2:0] ALU_OP,
    input wire [4:0] W_Addr,
    input wire [4:0] RS,
    input wire [4:0] RT,
    output wire [31:0] A,
    output wire [31:0] Data_Bus,
    output reg [31:0] Result, // Change wire to reg
    output wire OF,
    output wire ZF
);wire [31:0] B;

    // Register File
    reg [31:0] Register_File [31:0];
    integer i; // For loop index
    always @(posedge clk) begin
        if (Reset) begin
            for (i = 0; i < 32; i = i + 1) // Clear all registers on reset
                Register_File[i] <= 0;
        end else begin
            if (Write_Reg) begin
                Register_File[W_Addr] <= Data_Bus;
            end
        end
    end

    // ALU
    wire [31:0] A_signed, B_signed;
    assign A_signed = A; // A doesn't need $signed if it's already a wire
    assign B_signed = $signed({{16{1'b0}}, offset});
    always @(*) begin
        case (ALU_OP)
            3'b000: Result = A_signed + B_signed;
            3'b001: Result = A_signed - B_signed;
            3'b010: Result = A_signed & B_signed;
            3'b011: Result = A_signed | B_signed;
            3'b100: Result = A_signed ^ B_signed;
            3'b101: Result = A_signed << offset;
            3'b110: Result = A_signed >> offset;
            3'b111: Result = A_signed; // This might need to be defined more clearly
            default: Result = 32'b0; // To handle undefined ALU_OP
        endcase
    end

    // Memory
    reg [31:0] Memory [1023:0];
    always @(posedge clk) begin
        if (Reset) begin
            for (i = 0; i < 1024; i = i + 1) // Clear all memory on reset
                Memory[i] <= 0;
        end else begin
            if (Mem_Write) begin
                Memory[Result[7:2]] <= Data_Bus;
            end
        end
    end

    // Output
    assign A = Register_File[RS];
    assign B = Register_File[RT];
    assign Data_Bus = (Mem_Write) ? B : Result;
    assign OF = (Result[31] != Result[30]); // Overflow can vary based on ALU operation
    assign ZF = (Result == 0);

endmodule