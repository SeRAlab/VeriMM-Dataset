module top_module(
    
    
    input wire [31:0] di_PC,
    
    output reg [31:0] do_IR,
    
    output reg [31:0] do_NextPC,

    
    output wire [31:0] icache_address,
    input wire icache_hit,
    input wire icache_should_stall,
    input wire [31:0] icache_data
 );assign icache_address = di_PC;

always @(*) begin
    if (icache_should_stall && !icache_hit) begin
        do_NextPC = di_PC;
        do_IR = 0;
    end else begin
        do_NextPC = di_PC + 4;
        do_IR = icache_data;
    end
end

endmodule