`timescale 1ns/1ps

module astar_cost_calculator_tb;

    // Testbench signals (combinational circuit)
    reg control;
    reg [7:0] current_cost;
    reg [7:0] estimated_cost;
    wire [7:0] total_cost;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    astar_cost_calculator dut (
        .control(control),
        .current_cost(current_cost),
        .estimated_cost(estimated_cost),
        .total_cost(total_cost)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Control Low (Default Value Output)");
            control = 0;
            current_cost = 8'd10;
            estimated_cost = 8'd20;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Basic Addition (Control High)");
            control = 1;
            current_cost = 8'd15;
            estimated_cost = 8'd25;
            #1;

            check_outputs(8'd40);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Addition with Zero");
            control = 1;
            current_cost = 8'd0;
            estimated_cost = 8'd100;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Maximum value without Overflow");
            control = 1;
            current_cost = 8'd200;
            estimated_cost = 8'd55;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Overflow Handling (8-bit wrap-around)");
            control = 1;
            current_cost = 8'd130;
            estimated_cost = 8'd130;

            #1;


            check_outputs(8'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Maximum inputs (Overflow)");
            control = 1;
            current_cost = 8'hFF;
            estimated_cost = 8'hFF;

            #1;


            check_outputs(8'hFE);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Disable Control after Calculation");
            control = 1;
            current_cost = 8'd50;
            estimated_cost = 8'd50;
            #5;
            control = 0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("astar_cost_calculator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
