`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in1;
    reg [31:0] in2;
    wire out1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .out1(out1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive Comparison (5 < 10)", test_num);
            in1 = 32'sd5;
            in2 = 32'sd10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive Comparison (10 < 5)", test_num);
            in1 = 32'sd10;
            in2 = 32'sd5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Equality Positive (15 == 15)", test_num);
            in1 = 32'sd15;
            in2 = 32'sd15;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative Comparison (-10 < -5)", test_num);
            in1 = -32'sd10;
            in2 = -32'sd5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative Comparison (-5 < -10)", test_num);
            in1 = -32'sd5;
            in2 = -32'sd10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed Sign (-1 < 1)", test_num);
            in1 = -32'sd1;
            in2 = 32'sd1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed Sign (1 < -1)", test_num);
            in1 = 32'sd1;
            in2 = -32'sd1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero and Positive (0 < 100)", test_num);
            in1 = 32'sd0;
            in2 = 32'sd100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero and Negative (0 < -100)", test_num);
            in1 = 32'sd0;
            in2 = -32'sd100;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed Maximum Boundary (MaxPositive < MinNegative)", test_num);
            in1 = 32'h7FFFFFFF;
            in2 = 32'h80000000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed Minimum Boundary (MinNegative < MaxPositive)", test_num);
            in1 = 32'h80000000;
            in2 = 32'h7FFFFFFF;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large Negative vs Small Negative (-2147483648 < -1)", test_num);
            in1 = 32'h80000000;
            in2 = -32'sd1;
            #1;

            check_outputs(1'b1);
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
        testcase011();
        testcase012();
        
        
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
        input expected_out1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1)) begin
                $display("PASS");
                $display("  Outputs: out1=%b",
                         out1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%b",
                         expected_out1);
                $display("  Got:      out1=%b",
                         out1);
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
