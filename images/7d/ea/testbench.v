`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] Input;
    wire [11:0] Output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Input(Input),
        .Output(Output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple unit increment (000 -> 001)", test_num);
            Input = 12'h000;
            #1;

            check_outputs(12'h001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple unit increment (123 -> 124)", test_num);
            Input = 12'h123;
            #1;

            check_outputs(12'h124);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Carry from units to tens (009 -> 010)", test_num);
            Input = 12'h009;
            #1;

            check_outputs(12'h010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Carry from units to tens (159 -> 160)", test_num);
            Input = 12'h159;
            #1;

            check_outputs(12'h160);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Carry from tens to hundreds (099 -> 100)", test_num);
            Input = 12'h099;
            #1;

            check_outputs(12'h100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Double carry with non-zero hundred (499 -> 500)", test_num);
            Input = 12'h499;
            #1;

            check_outputs(12'h500);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum value wrap around (999 -> 000)", test_num);
            Input = 12'h999;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: High hundred value increment (898 -> 899)", test_num);
            Input = 12'h898;
            #1;

            check_outputs(12'h899);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Random intermediate value (741 -> 742)", test_num);
            Input = 12'h741;
            #1;

            check_outputs(12'h742);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Carry to high hundred (899 -> 900)", test_num);
            Input = 12'h899;
            #1;

            check_outputs(12'h900);
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
        input [11:0] expected_Output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Output === (expected_Output ^ Output ^ expected_Output)) begin
                $display("PASS");
                $display("  Outputs: Output=%h",
                         Output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Output=%h",
                         expected_Output);
                $display("  Got:      Output=%h",
                         Output);
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
