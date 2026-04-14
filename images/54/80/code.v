module top_module(
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q,
    output out_and,
    output out_or,
    output out_xor
);// 4-digit binary counter with enable signals
    reg [3:0] count;
    reg [3:1] ena_reg;
    wire [3:0] inc_signals;
    wire [3:0] mux_inputs;
    wire [3:0] mux_select;
    
    // Combinational logic circuit
    wire [15:0] count_wire;
    wire [15:0] and_wire;
    wire [15:0] or_wire;
    wire [15:0] xor_wire;
    wire [1:0] select;
    
    // Control logic
    always @ (posedge clk, posedge reset) begin
        if (reset) begin
            count <= 0;
            ena_reg <= 0;
        end else begin
            count <= count + inc_signals;
            ena_reg <= ena;
        end
    end
    
    // Multiplexers for counter
    assign mux_inputs = {count[3:1], count[2:0], count[1:0], count[0]};
    assign mux_select = {3'b000, ena_reg};
    assign inc_signals = {1'b0, ena_reg};
    assign q = {mux_inputs[3:0], mux_inputs[3:0]};
    
    // Combinational logic circuit
    assign count_wire = {q, q};
    assign and_wire = count_wire & {16{1'b1}};
    assign or_wire = count_wire | {16{1'b0}};
    assign xor_wire = count_wire ^ {16{1'b1}};
    
    // Multiplexers for logic circuit
    assign out_and = select[0] ? and_wire[15] : and_wire[7];
    assign out_or = select[0] ? or_wire[15] : or_wire[7];
    assign out_xor = select[0] ? xor_wire[15] : xor_wire[7];
    assign select = count[3] ? 2'b10 : (count[2] ? 2'b01 : 2'b00);

endmodule