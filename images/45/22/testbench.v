`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] dividend;
    reg [31:0] divisor;
    reg enable;
    wire done;
    wire [31:0] quotient;
    wire [31:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dividend(dividend),
        .divisor(divisor),
        .enable(enable),
        .done(done),
        .quotient(quotient),
        .remainder(remainder)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 20 / 3", test_num);
            enable = 0;
            dividend = 32'sd20;
            divisor = 32'sd3;
            #10;
            enable = 1;
            wait(done);
            #1;

            check_outputs(1'b1, 32'sd6, 32'sd2);
            enable = 0;
            #20;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: -20 / 3", test_num);
            enable = 0;
            dividend = -32'sd20;
            divisor = 32'sd3;
            #10;
            enable = 1;
            wait(done);
            #1;

            check_outputs(1'b1, -32'sd6, -32'sd2);
            enable = 0;
            #20;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 20 / -3", test_num);
            enable = 0;
            dividend = 32'sd20;
            divisor = -32'sd3;
            #10;
            enable = 1;
            wait(done);
            #1;

            check_outputs(1'b1, -32'sd6, 32'sd2);
            enable = 0;
            #20;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: -20 / -3", test_num);
            enable = 0;
            dividend = -32'sd20;
            divisor = -32'sd3;
            #10;
            enable = 1;
            wait(done);
            #1;

            check_outputs(1'b1, 32'sd6, -32'sd2);
            enable = 0;
            #20;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Division by Zero", test_num);
            enable = 0;
            dividend = 32'sd500;
            divisor = 32'sd0;
            #10;
            enable = 1;
            wait(done);
            #1;

            check_outputs(1'b1, 32'sd0, 32'sd0);
            enable = 0;
            #20;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 0 / 100", test_num);
            enable = 0;
            dividend = 32'sd0;
            divisor = 32'sd100;
            #10;
            enable = 1;
            wait(done);
            #1;

            check_outputs(1'b1, 32'sd0, 32'sd0);
            enable = 0;
            #20;
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 5 / 10", test_num);
            enable = 0;
            dividend = 32'sd5;
            divisor = 32'sd10;
            #10;
            enable = 1;
            wait(done);
            #1;

            check_outputs(1'b1, 32'sd0, 32'sd5);
            enable = 0;
            #20;
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 100 / 10", test_num);
            enable = 0;
            dividend = 32'sd100;
            divisor = 32'sd10;
            #10;
            enable = 1;
            wait(done);
            #1;

            check_outputs(1'b1, 32'sd10, 32'sd0);
            enable = 0;
            #20;
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 2147483647 / -1", test_num);
            enable = 0;
            dividend = 32'sh7FFFFFFF;
            divisor = -32'sd1;
            #10;
            enable = 1;
            wait(done);
            #1;

            check_outputs(1'b1, -32'sd2147483647, 32'sd0);
            enable = 0;
            #20;
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: -50 / -50", test_num);
            enable = 0;
            dividend = -32'sd50;
            divisor = -32'sd50;
            #10;
            enable = 1;
            wait(done);
            #1;

            check_outputs(1'b1, 32'sd1, 32'sd0);
            enable = 0;
            #20;
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
        input expected_done;
        input [31:0] expected_quotient;
        input [31:0] expected_remainder;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: done=%b, quotient=%h, remainder=%h",
                         done, quotient, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, quotient=%h, remainder=%h",
                         expected_done, expected_quotient, expected_remainder);
                $display("  Got:      done=%b, quotient=%h, remainder=%h",
                         done, quotient, remainder);
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
