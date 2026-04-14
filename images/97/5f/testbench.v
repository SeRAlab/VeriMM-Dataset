`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] lhs;
    reg [11:0] rhs;
    wire overflow;
    wire [11:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .lhs(lhs),
        .rhs(rhs),
        .overflow(overflow),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple subtraction (10 - 5)", test_num);
            lhs = 12'd10;
            rhs = 12'd5;
            #1;

            check_outputs(1'b0, 12'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction resulting in zero (2048 - 2048)", test_num);
            lhs = 12'd2048;
            rhs = 12'd2048;
            #1;

            check_outputs(1'b0, 12'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max value minus zero (4095 - 0)", test_num);
            lhs = 12'hFFF;
            rhs = 12'h000;
            #1;

            check_outputs(1'b0, 12'hFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum overflow (0 - 1)", test_num);
            lhs = 12'd0;
            rhs = 12'd1;

            #1;


            check_outputs(1'b1, 12'hFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum overflow (0 - 4095)", test_num);
            lhs = 12'd0;
            rhs = 12'hFFF;

            #1;


            check_outputs(1'b1, 12'h001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Intermediate overflow (1000 - 2000)", test_num);
            lhs = 12'd1000;
            rhs = 12'd2000;

            #1;


            check_outputs(1'b1, 12'd3096);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary check (4095 - 4094)", test_num);
            lhs = 12'hFFF;
            rhs = 12'hFFE;
            #1;

            check_outputs(1'b0, 12'h001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern subtraction (0xA5A - 0x5A5)", test_num);
            lhs = 12'hA5A;
            rhs = 12'h5A5;
            #1;

            check_outputs(1'b0, 12'h4B5);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern subtraction with overflow (0x5A5 - 0xA5A)", test_num);
            lhs = 12'h5A5;
            rhs = 12'hA5A;

            #1;


            check_outputs(1'b1, 12'hB4B);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small values (2 - 1)", test_num);
            lhs = 12'd2;
            rhs = 12'd1;
            #1;

            check_outputs(1'b0, 12'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_overflow;
        input [11:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, result=%h",
                         overflow, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, result=%h",
                         expected_overflow, expected_result);
                $display("  Got:      overflow=%b, result=%h",
                         overflow, result);
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
