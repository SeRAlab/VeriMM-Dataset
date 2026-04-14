module top_module(AS,
     out,
     wr_clk,
     in0);output [0:0] AS;
    output out;
    input wr_clk;
    input [0:0] in0;

    reg [1:0] buffer;          // Change wire to reg for storage
    reg [1:0] next_buffer;     // Change wire to reg for storage
    reg full;                  // Change wire to reg for storage

    assign AS = full;
    assign out = buffer[0];

    always @ (posedge wr_clk) begin
        if (!full) begin
            next_buffer[1] <= buffer[0];
            next_buffer[0] <= in0;
        end else begin
            next_buffer <= buffer;
        end
        buffer <= next_buffer;  // Move buffer update inside the same always block
    end

    always @ (buffer) begin  // Remove full from sensitivity list as it's updated synchronously
        full = (buffer[1] != 1'b0);
    end

endmodule