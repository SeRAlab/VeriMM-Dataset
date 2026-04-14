module top_module(
    input A1,
    input A2,
    input A3,
    input A4,
    input B1,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output reg X
);reg [4:0] inputs;
reg [4:0] old_inputs;

// The inputs should be assigned in an always block to avoid unresolved wires
always @* begin
    inputs = {A1, A2, A3, A4, B1};
end

always @(posedge VPWR or negedge VGND) begin
    if (VGND == 0) begin
        X <= 1'bx;
        old_inputs <= 5'bxxxxx; // Initialize old_inputs on power down
    end else if (inputs != old_inputs) begin
        if (inputs == 5'b00000) begin
            X <= 1'b0;
        end else if (inputs == 5'b11111) begin
            X <= 1'b1;
        end else begin
            X <= 1'bx;
        end
        old_inputs <= inputs;
    end
end

endmodule