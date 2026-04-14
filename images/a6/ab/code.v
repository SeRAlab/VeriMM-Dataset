module top_module(
    input       valid,
    input [2:0] pri_in,
    input [3:0] ch_conf,  // declare ch_conf as input
    input [1:0] pri_sel,   // declare pri_sel as input
    output reg [7:0] pri_out  // output type changed to reg for compatibility with always blocks
);reg [7:0] pri_out_d;
reg [7:0] pri_out_d0;
reg [7:0] pri_out_d1;
reg [7:0] pri_out_d2;

assign pri_out = ch_conf[0] ? pri_out_d : 8'h0;

// Select Configured Priority
always @(pri_sel or pri_out_d0 or pri_out_d1 or  pri_out_d2) begin
    case(pri_sel)  // synopsys parallel_case full_case
        2'd0: pri_out_d = pri_out_d0;
        2'd1: pri_out_d = pri_out_d1;
        2'd2: pri_out_d = pri_out_d2;
        default: pri_out_d = 8'h0; // Handling for default case
    endcase
end

// 8 Priority Levels
always @(valid or pri_in) begin
    if(!valid) pri_out_d2 = 8'b0000_0001;
    else if(pri_in == 3'h0) pri_out_d2 = 8'b0000_0001;
    else if(pri_in == 3'h1) pri_out_d2 = 8'b0000_0010;
    else if(pri_in == 3'h2) pri_out_d2 = 8'b0000_0100;
    else if(pri_in == 3'h3) pri_out_d2 = 8'b0000_1000;
    else if(pri_in == 3'h4) pri_out_d2 = 8'b0001_0000;
    else if(pri_in == 3'h5) pri_out_d2 = 8'b0010_0000;
    else if(pri_in == 3'h6) pri_out_d2 = 8'b0100_0000;
    else pri_out_d2 = 8'b1000_0000;
end

// 4 Priority Levels
always @(valid or pri_in) begin
    if(!valid) pri_out_d1 = 8'b0000_0001;
    else if(pri_in == 3'h0) pri_out_d1 = 8'b0000_0001;
    else if(pri_in == 3'h1) pri_out_d1 = 8'b0000_0010;
    else if(pri_in == 3'h2) pri_out_d1 = 8'b0000_0100;
    else pri_out_d1 = 8'b0000_1000;
end

// 2 Priority Levels
always @(valid or pri_in) begin
    if(!valid) pri_out_d0 = 8'b0000_0001;
    else if(pri_in == 3'h0) pri_out_d0 = 8'b0000_0001;
    else pri_out_d0 = 8'b0000_0010;
end

endmodule