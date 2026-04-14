module branch_predictor (
    input wire [1:0] branch_address,   // 2-bit branch address for selecting BHT entry
    input wire branch_outcome,          // 1-bit branch outcome (1 for taken, 0 for not taken)
    input wire clk,                     // Clock input
    output reg prediction                // 1-bit prediction output
);
    // 4 entries for 2-bit saturating counters
    reg [1:0] bht [0:3];                // 2-bit counter for each of the 4 entries

    // Initial state of BHT
    initial begin
        bht[0] = 2'b00;  // Strongly Not Taken
        bht[1] = 2'b00;  // Strongly Not Taken
        bht[2] = 2'b00;  // Strongly Not Taken
        bht[3] = 2'b00;  // Strongly Not Taken
    end

    // Output prediction based on current state
    always @(*) begin
        prediction = (bht[branch_address] >= 2'b10); // Predict taken if counter is 2'b10 or 2'b11
    end

    // Update BHT on clock edge
    always @(posedge clk) begin
        if (branch_outcome) begin
            // Taken: increment the counter but saturate at 2'b11
            if (bht[branch_address] < 2'b11)
                bht[branch_address] <= bht[branch_address] + 1;
        end else begin
            // Not taken: decrement the counter but saturate at 2'b00
            if (bht[branch_address] > 2'b00)
                bht[branch_address] <= bht[branch_address] - 1;
        end
    end
endmodule