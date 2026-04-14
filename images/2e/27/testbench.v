`timescale 1ns/1ps

module AStarHeuristic_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] current_cost;
    reg [7:0] heuristic_cost;
    wire [7:0] total_cost;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AStarHeuristic dut (
        .current_cost(current_cost),
        .heuristic_cost(heuristic_cost),
        .total_cost(total_cost)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All zeros", test_num);
            current_cost = 8'd0;
            heuristic_cost = 8'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple addition", test_num);
            current_cost = 8'd10;
            heuristic_cost = 8'd20;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero heuristic", test_num);
            current_cost = 8'd55;
            heuristic_cost = 8'd0;
            #1;

            check_outputs(8'd55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero current cost", test_num);
            current_cost = 8'd0;
            heuristic_cost = 8'd128;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum value without overflow", test_num);
            current_cost = 8'd127;
            heuristic_cost = 8'd128;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Overflow condition (255 + 1)", test_num);
            current_cost = 8'd255;
            heuristic_cost = 8'd1;

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: General overflow", test_num);
            current_cost = 8'd200;
            heuristic_cost = 8'd100;

            #1;


            check_outputs(8'd44);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Max overflow", test_num);
            current_cost = 8'hFF;
            heuristic_cost = 8'hFF;

            #1;


            check_outputs(8'hFE);
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
        input [7:0] expected_total_cost;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_total_cost === (expected_total_cost ^ total_cost ^ expected_total_cost)) begin
                $display("PASS");
                $display("  Outputs: total_cost=%h",
                         total_cost);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: total_cost=%h",
                         expected_total_cost);
                $display("  Got:      total_cost=%h",
                         total_cost);
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
