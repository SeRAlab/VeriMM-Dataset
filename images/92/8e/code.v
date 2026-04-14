module top_module(
    input  clk,            // bus clock
    input  reset,          // reset
    input  [15:0] in,      // data in
    output reg [15:0] out, // data out
    input  rd,             // read from fifo
    input  wr,             // write to fifo
    output reg empty,      // fifo is empty
    output reg full,       // fifo is full
    output [11:0] cnt      // number of entries in FIFO
);// local signals and registers
    reg  [15:0] mem [2047:0]; // 2048 words by 16 bit wide fifo memory (for 2 MFM-encoded sectors)
    reg  [11:0] in_ptr;       // fifo input pointer
    reg  [11:0] out_ptr;      // fifo output pointer
    wire equal;               // lower 11 bits of in_ptr and out_ptr are equal

    // count of FIFO entries
    assign cnt = in_ptr - out_ptr;

    // main fifo memory (implemented using synchronous block ram)
    always @(posedge clk)
    if (wr)
        mem[in_ptr[10:0]] <= in;

    always @(posedge clk)
    out=mem[out_ptr[10:0]];

    // fifo write pointer control
    always @(posedge clk)
    if (reset)
        in_ptr[11:0] <= 0;
    else if(wr)
        in_ptr[11:0] <= in_ptr[11:0] + 12'd1;

    // fifo read pointer control
    always @(posedge clk)
    if (reset)
        out_ptr[11:0] <= 0;
    else if (rd)
        out_ptr[11:0] <= out_ptr[11:0] + 12'd1;

    // check lower 11 bits of pointer to generate equal signal
    assign equal = (in_ptr[10:0]==out_ptr[10:0]) ? 1'b1 : 1'b0;

    // assign output flags, empty is delayed by one clock to handle ram delay
    always @(posedge clk)
    if (equal && (in_ptr[11]==out_ptr[11]))
        empty <= 1'b1;
    else
        empty <= 1'b0;
    
    always @(posedge clk)
    if (equal && (in_ptr[11]!=out_ptr[11]))
        full <= 1'b1;
    else
        full <= 1'b0;

endmodule