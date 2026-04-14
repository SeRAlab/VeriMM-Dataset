module portfolio_allocation(
    input [3:0] weight1,
    input [3:0] weight2,
    input [3:0] weight3,
    input [3:0] budget,
    output reg [3:0] allocation1,
    output reg [3:0] allocation2,
    output reg [3:0] allocation3
);
    reg [7:0] total_weight;
    reg [7:0] proportional_allocation1;
    reg [7:0] proportional_allocation2;
    reg [7:0] proportional_allocation3;

    always @(*) begin
        // Calculate total weight
        total_weight = weight1 + weight2 + weight3;
        
        // If total weight is zero, allocation should be zero
        if (total_weight == 0) begin
            allocation1 = 0;
            allocation2 = 0;
            allocation3 = 0;
        end else begin
            // Calculate proportional allocation
            proportional_allocation1 = (weight1 * budget) / total_weight;
            proportional_allocation2 = (weight2 * budget) / total_weight;
            proportional_allocation3 = (weight3 * budget) / total_weight;

            // Limit allocation to budget
            allocation1 = (proportional_allocation1 > budget) ? budget : proportional_allocation1[3:0];
            allocation2 = (proportional_allocation2 > budget) ? budget : proportional_allocation2[3:0];
            allocation3 = (proportional_allocation3 > budget) ? budget : proportional_allocation3[3:0];
        end
    end
endmodule