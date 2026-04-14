module top_module(
    input A,
    input B,
    input C,
    input [3:0] data_in,
    input dir,
    output [3:0] data_out
);// 3-to-8 decoder
    wire [7:0] decoder_out;
    assign decoder_out = ~(A&B&C) << 3 | ~(A&B&~C) << 2 | ~(A&~B&C) << 1 | ~(A&~B&~C) << 0 | ~(~A&B&C) << 4 | ~(~A&B&~C) << 5 | ~(~A&~B&C) << 6 | ~(~A&~B&~C) << 7;
    
    // Barrel shifter
    wire [3:0] shifted_data;
    assign shifted_data = dir ? data_in >> 1 : data_in << 1;
    assign data_out = (decoder_out & 8'hFF) == 0 ? data_in : shifted_data;

endmodule