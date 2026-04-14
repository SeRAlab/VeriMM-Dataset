`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] dividend;
    reg [15:0] divisor;
    wire [15:0] quotient;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dividend(dividend),
        .divisor(divisor),
        .quotient(quotient)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Division (100 / 10)", test_num);
            dividend = 16'd100;
            divisor = 16'd10;
            #1;

            check_outputs(16'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division by One (500 / 1)", test_num);
            dividend = 16'd500;
            divisor = 16'd1;
            #1;

            check_outputs(16'd500);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dividend Less Than Divisor (5 / 10)", test_num);
            dividend = 16'd5;
            divisor = 16'd10;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division of Equal Values (2048 / 2048)", test_num);
            dividend = 16'd2048;
            divisor = 16'd2048;
            #1;

            check_outputs(16'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Unsigned Dividend (65535 / 255)", test_num);
            dividend = 16'hFFFF;
            divisor = 16'd255;
            #1;

            check_outputs(16'd257);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Power of Two Division (16384 / 128)", test_num);
            dividend = 16'd16384;
            divisor = 16'd128;
            #1;

            check_outputs(16'd128);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division with Remainder (10 / 3)", test_num);
            dividend = 16'd10;
            divisor = 16'd3;
            #1;

            check_outputs(16'd3);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative Divisor Handling (20 / -5)", test_num);



            dividend = 16'd20;
            divisor = 16'hFFFB;
            #1;

            check_outputs(16'd4);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Dividend (0 / 123)", test_num);
            dividend = 16'd0;
            divisor = 16'd123;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Value Division (60000 / 120)", test_num);
            dividend = 16'd60000;
            divisor = 16'd120;
            #1;

            check_outputs(16'd500);
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
        input [15:0] expected_quotient;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h",
                         quotient);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h",
                         expected_quotient);
                $display("  Got:      quotient=%h",
                         quotient);
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
