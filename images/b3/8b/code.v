module top_module(
    input a,
    input b,
    input [1:0] sel2, // select input for the second multiplexer
    input [3:0] data2_0, // input data for the second multiplexer
    input [3:0] data2_1, // input data for the second multiplexer
    input [1:0] sel1, // select input for the first multiplexer
    input [3:0] data1_0, // input data for the first multiplexer
    input [3:0] data1_1, // input data for the first multiplexer
    input [3:0] data1_2, // input data for the first multiplexer
    input [3:0] data1_3, // input data for the first multiplexer
    input [3:0] data1_4, // input data for the first multiplexer
    input [3:0] data1_5, // input data for the first multiplexer
    output out_wire // output of the XOR gate
);// Priority encoder for the first multiplexer
wire [2:0] priority_enc;
assign priority_enc = {data1_0[3], data1_1[3], data1_2[3], data1_3[3], data1_4[3], data1_5[3]};

// First multiplexer
reg [3:0] mux1_out; // changed to 'reg' as it needs to store value in procedural block
always @(*) begin
    case(sel1)
        2'b00: mux1_out = data1_0;
        2'b01: mux1_out = data1_1;
        2'b10: mux1_out = data1_2;
        2'b11: mux1_out = data1_3;
        default: mux1_out = 4'b0000; // Added default case
    endcase
end

// Priority encoder for the second multiplexer
wire [1:0] priority_enc2;
assign priority_enc2 = {data2_0[3], data2_1[3]};

// Second multiplexer
reg [1:0] mux2_out; // changed to 'reg' as it needs to store value in procedural block
always @(*) begin
    case(sel2)
        2'b00: mux2_out = data2_0[1:0];
        2'b01: mux2_out = data2_0[3:2];
        2'b10: mux2_out = data2_1[1:0];
        2'b11: mux2_out = data2_1[3:2];
        default: mux2_out = 2'b00; // Added default case
    endcase
end

// XOR gate
reg xor_out; // changed to 'reg' as it needs to store value in procedural block
always @(*) begin
    xor_out = a ^ b;
end

// Output
assign out_wire = xor_out;

endmodule