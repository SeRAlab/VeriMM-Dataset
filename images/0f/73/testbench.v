`timescale 1ns/1ps

module SRT_Divider_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] dividend;
    reg [4:0] divisor;
    wire [4:0] quotient;
    wire [3:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRT_Divider dut (
        .dividend(dividend),
        .divisor(divisor),
        .quotient(quotient),
        .remainder(remainder)
    );
    task testcase001;

    begin
        test_num = 1;
        dividend = 5'sd10; divisor = 5'sd3;
        $display("Test Case %0d: Positive / Positive (10 / 3)", test_num);
        #1;

        check_outputs(5'sd3, 4'sd1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        dividend = -5'sd10; divisor = 5'sd3;
        $display("Test Case %0d: Negative / Positive (-10 / 3)", test_num);
        #1;

        check_outputs(-5'sd3, -4'sd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        dividend = 5'sd10; divisor = -5'sd3;
        $display("Test Case %0d: Positive / Negative (10 / -3)", test_num);
        #1;

        check_outputs(-5'sd3, 4'sd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        dividend = -5'sd10; divisor = -5'sd3;
        $display("Test Case %0d: Negative / Negative (-10 / -3)", test_num);
        #1;

        check_outputs(5'sd3, -4'sd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        dividend = 5'sd0; divisor = 5'sd5;
        $display("Test Case %0d: Zero Dividend (0 / 5)", test_num);
        #1;

        check_outputs(5'sd0, 4'sd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        dividend = 5'sd15; divisor = 5'sd5;
        $display("Test Case %0d: Exact Division (15 / 5)", test_num);
        #1;

        check_outputs(5'sd3, 4'sd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        dividend = -5'sd16; divisor = 5'sd4;
        $display("Test Case %0d: Minimum Dividend (-16 / 4)", test_num);
        #1;

        check_outputs(-5'sd4, 4'sd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        dividend = 5'sd7; divisor = 5'sd2;
        $display("Test Case %0d: Small Positive Division (7 / 2)", test_num);
        #1;

        check_outputs(5'sd3, 4'sd1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        dividend = -5'sd7; divisor = 5'sd2;
        $display("Test Case %0d: Small Negative Dividend (-7 / 2)", test_num);
        #1;

        check_outputs(-5'sd3, -4'sd1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        dividend = 5'sd5; divisor = 5'sd8;
        $display("Test Case %0d: Dividend < Divisor (5 / 8)", test_num);
        #1;

        check_outputs(5'sd0, 4'sd5);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        dividend = -5'sd15; divisor = 5'sd8;
        $display("Test Case %0d: Large Remainder (-15 / 8)", test_num);
        #1;

        check_outputs(-5'sd1, -4'sd7);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        dividend = 5'sd1; divisor = 5'sd1;
        $display("Test Case %0d: Divide by One (1 / 1)", test_num);
        #1;

        check_outputs(5'sd1, 4'sd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRT_Divider Testbench");
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
        input [4:0] expected_quotient;
        input [3:0] expected_remainder;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h, remainder=%h",
                         quotient, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h, remainder=%h",
                         expected_quotient, expected_remainder);
                $display("  Got:      quotient=%h, remainder=%h",
                         quotient, remainder);
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
