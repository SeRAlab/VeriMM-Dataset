`timescale 1ns/1ps

module AStarHeuristic_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] current_cost;
    reg [7:0] estimated_cost;
    wire [7:0] total_estimated_cost;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AStarHeuristic dut (
        .current_cost(current_cost),
        .estimated_cost(estimated_cost),
        .total_estimated_cost(total_estimated_cost)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Zero inputs", test_num);
        current_cost = 8'd0;
        estimated_cost = 8'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Small values", test_num);
        current_cost = 8'd10;
        estimated_cost = 8'd25;
        #1;

        check_outputs(8'd35);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Current cost max, zero heuristic", test_num);
        current_cost = 8'd255;
        estimated_cost = 8'd0;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Zero current cost, max heuristic", test_num);
        current_cost = 8'd0;
        estimated_cost = 8'd255;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Mid-range values", test_num);
        current_cost = 8'd127;
        estimated_cost = 8'd128;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Overflow check (Simple)", test_num);
        current_cost = 8'd200;
        estimated_cost = 8'd100;

        #1;


        check_outputs(8'd44);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Maximum overflow check", test_num);
        current_cost = 8'd255;
        estimated_cost = 8'd255;

        #1;


        check_outputs(8'd254);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Hexadecimal pattern 1", test_num);
        current_cost = 8'hAA;
        estimated_cost = 8'h55;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Hexadecimal pattern 2", test_num);
        current_cost = 8'h33;
        estimated_cost = 8'hCC;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Prime number addition", test_num);
        current_cost = 8'd17;
        estimated_cost = 8'd43;
        #1;

        check_outputs(8'd60);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AStarHeuristic Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [7:0] expected_total_estimated_cost;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_total_estimated_cost === (expected_total_estimated_cost ^ total_estimated_cost ^ expected_total_estimated_cost)) begin
                $display("PASS");
                $display("  Outputs: total_estimated_cost=%h",
                         total_estimated_cost);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: total_estimated_cost=%h",
                         expected_total_estimated_cost);
                $display("  Got:      total_estimated_cost=%h",
                         total_estimated_cost);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

endmodule
