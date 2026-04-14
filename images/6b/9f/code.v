module top_module(
    output reg isBranch,
    input [5:0] opcode,
    input flag_z, flag_n, flag_v
);localparam B = 6'b010011;
localparam BEQ = 6'b010100;
localparam BGT = 6'b010101;
localparam BGE = 6'b010110;
localparam BLE = 6'b010111;
localparam BLT = 6'b011000;  
localparam BNE = 6'b011001; 

always @(opcode or flag_n or flag_z or flag_v) begin
    case (opcode)
        B: isBranch = 1;
        BEQ: isBranch = flag_z;
        BGT: isBranch = (~flag_z) && (~flag_n);   
        BGE: isBranch = (~flag_n);
        BLE: isBranch = flag_z | flag_n;
        BLT: isBranch = flag_n;
        BNE: isBranch = ~flag_z;
        default: isBranch = 0;
    endcase
end
   
endmodule