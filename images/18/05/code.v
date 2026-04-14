module priority_arbiter (
    input [3:0] req,    // Request signals from 4 requestors
    output reg [3:0] grant // Grant signal indicating which requestor is granted access
);
    always @(*) begin
        grant = 4'b0000; // Default to no grants
        if (req[0]) grant = 4'b0001; // Grant to Requestor 0
        else if (req[1]) grant = 4'b0010; // Grant to Requestor 1
        else if (req[2]) grant = 4'b0100; // Grant to Requestor 2
        else if (req[3]) grant = 4'b1000; // Grant to Requestor 3
    end
endmodule