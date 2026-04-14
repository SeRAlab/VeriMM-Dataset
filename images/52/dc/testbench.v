`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] dividend;
    reg [31:0] divisor;
    wire [63:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dividend(dividend),
        .divisor(divisor),
        .z(z)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive / Positive (Exact)", test_num);
            dividend = 32'sd100;
            divisor  = 32'sd10;

            #1;


            check_outputs({32'sd0, 32'sd10});
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive / Positive (With Remainder)", test_num);
            dividend = 32'sd10;
            divisor  = 32'sd3;

            #1;


            check_outputs({32'sd1, 32'sd3});
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative / Positive", test_num);
            dividend = -32'sd10;
            divisor  = 32'sd3;

            #1;


            check_outputs({-32'sd1, -32'sd3});
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive / Negative", test_num);
            dividend = 32'sd10;
            divisor  = -32'sd3;

            #1;


            check_outputs({32'sd1, -32'sd3});
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative / Negative", test_num);
            dividend = -32'sd10;
            divisor  = -32'sd3;

            #1;


            check_outputs({-32'sd1, 32'sd3});
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dividend is Zero", test_num);
            dividend = 32'sd0;
            divisor  = 32'sd50;

            #1;


            check_outputs({32'sd0, 32'sd0});
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large Numbers", test_num);
            dividend = 32'sd2147483647;
            divisor  = 32'sd2;

            #1;


            check_outputs({32'sd1, 32'sd1073741823});
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Minimum Signed Integer / Positive", test_num);
            dividend = -32'sd2147483648;
            divisor  = 32'sd1;

            #1;


            check_outputs({32'sd0, -32'sd2147483648});
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Divisor > Dividend", test_num);
            dividend = 32'sd5;
            divisor  = 32'sd10;

            #1;


            check_outputs({32'sd5, 32'sd0});
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small Negative Dividend", test_num);
            dividend = -32'sd5;
            divisor  = 32'sd10;

            #1;


            check_outputs({-32'sd5, 32'sd0});
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
        input [63:0] expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: z=%h",
                         z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z=%h",
                         expected_z);
                $display("  Got:      z=%h",
                         z);
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
