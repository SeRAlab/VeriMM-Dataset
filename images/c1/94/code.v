module LED(
    input  clock,
    input  reset,
    input  [14:0] dataIn,
    input  [7:0] IP,
    input  Write,
    input  Read,
    output [13:0] dataOut,
    output reg Ack,
    output [13:0] LED
    );
    reg  [13:0] data;
    reg  useInterrupts;
    always @(posedge clock) begin
        data <= (reset) ? 14'b0 : ((Write) ? dataIn[13:0] : data);
        useInterrupts <= (reset) ? 0 : ((Write) ? dataIn[14] : useInterrupts);
    end
    always @(posedge clock) begin
        Ack <= (reset) ? 0 : (Write | Read);
    end
    assign LED = (useInterrupts) ? {6'b0, IP[7:0]} : data;
    assign dataOut = data;
endmodule