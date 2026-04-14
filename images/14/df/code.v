module fixed_priority_arbiter (
    input  wire [3:0] req,
    output reg  [3:0] grant
);
    always @(*) begin
        grant = 4'b0000; // Default grant signal
        case (1'b1) 
            req[0]: grant = 4'b0001; // Grant to req[0]
            req[1]: grant = 4'b0010; // Grant to req[1]
            req[2]: grant = 4'b0100; // Grant to req[2]
            req[3]: grant = 4'b1000; // Grant to req[3]
            default: grant = 4'b0000; // No grants
        endcase
    end
endmodule