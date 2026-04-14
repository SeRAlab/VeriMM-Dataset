module top_module(
    input clock,
    input [7:0] data_in,
    input shift_en,
    input load_en,
    output [31:0] data_out,
    output empty,
    output full
);reg [7:0] shift_reg [3:0];
reg [1:0] head = 2;
reg [1:0] tail = 2;
wire shift_out_en = (head == tail) ? load_en : 1'b1;
wire shift_in_en = (head != tail) ? shift_en : 1'b0;

// Shift in new data if shift_en is high and shift register is not full
always @(posedge clock) begin
    if (shift_in_en && !full) begin
        shift_reg[head] <= data_in;
        head <= (head == 0) ? 3 : head - 1;
    end
end

// Shift out oldest data if shift_en is high and shift register is full
always @(posedge clock) begin
    if (shift_out_en && !empty) begin
        tail <= (tail == 0) ? 3 : tail - 1;
    end
end

// Output data from shift register
assign data_out = {shift_reg[tail], shift_reg[(tail+1)%4], shift_reg[(tail+2)%4], shift_reg[(tail+3)%4]};

// Output signals indicating whether shift register is empty or full
assign empty = (head == tail) ? 1'b1 : 1'b0;
assign full = ((head+1)%4 == tail) ? 1'b1 : 1'b0;

endmodule