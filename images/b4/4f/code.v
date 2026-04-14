module top_module(
    input clk, // clock signal
    input clr, // clear signal
    input rst, // reset signal
    input up, // up signal
    input load, // load signal
    input [7:0] din, // data input signal
    input en, // enable signal
    output reg [4:0] op // output signal
);reg [4:0] count; // counter

always @ (posedge clk) begin
    if (clr) begin
        count <= 5'b0; // clear counter to 0
    end else if (rst) begin
        count <= din[4:0]; // reset counter to initial value
    end else if (load) begin
        count <= din[4:0]; // load initial value into counter
    end else if (en) begin
        if (up) begin
            count <= count + 5'b1; // count up
        end else begin
            count <= count - 5'b1; // count down
        end
    end
end

assign op = count; // assign output signal to counter value

endmodule