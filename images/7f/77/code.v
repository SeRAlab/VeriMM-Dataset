module top_module(
    input CLK,
    input RESET,
    input [7:0] INSTR,
    input [7:0] DATA,
    output reg [7:0] OUT,
    output reg FLAG
);reg [7:0] temp;

always @(posedge CLK) begin
    if (RESET) begin
        OUT <= 8'h00;
        FLAG <= 1;
    end else begin
        case (INSTR)
            8'h00: begin // NOP
                // Do nothing
            end
            8'h01: begin // ADD
                temp = OUT + DATA;
                OUT <= temp;
                FLAG <= 1;
            end
            8'h02: begin // SUB
                temp = OUT - DATA;
                OUT <= temp;
                FLAG <= 1;
            end
            8'h03: begin // MOV
                OUT <= DATA;
                FLAG <= 1;
            end
            8'h04: begin // CMP
                if (OUT == DATA) begin
                    FLAG <= 1;
                end else begin
                    FLAG <= 0;
                end
            end
            8'h05: begin // HLT
                // Do nothing
            end
        endcase
    end
end

endmodule