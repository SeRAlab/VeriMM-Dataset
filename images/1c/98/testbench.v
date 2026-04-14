`timescale 1ns/1ps

module SRT_Divider_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] dividend;
    reg [15:0] divisor;
    wire [15:0] quotient;
    wire [15:0] remainder;

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
        test_num = test_num + 1;
        $display("Test %0d: Basic Division (20 / 4)", test_num);
        dividend = 16'd20;
        divisor  = 16'd4;
        #1;

        check_outputs(16'd5, 16'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Division with Remainder (100 / 7)", test_num);
        dividend = 16'd100;
        divisor  = 16'd7;
        #1;

        check_outputs(16'd14, 16'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Dividend < Divisor (5 / 10)", test_num);
        dividend = 16'd5;
        divisor  = 16'd10;
        #1;

        check_outputs(16'd0, 16'd5);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Division by One (65535 / 1)", test_num);
        dividend = 16'hFFFF;
        divisor  = 16'd1;
        #1;

        check_outputs(16'hFFFF, 16'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Dividend equals Divisor (1024 / 1024)", test_num);
        dividend = 16'd1024;
        divisor  = 16'd1024;
        #1;

        check_outputs(16'd1, 16'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero Dividend (0 / 500)", test_num);
        dividend = 16'd0;
        divisor  = 16'd500;
        #1;

        check_outputs(16'd0, 16'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Power of Two Division (32768 / 256)", test_num);
        dividend = 16'd32768;
        divisor  = 16'd256;
        #1;

        check_outputs(16'd128, 16'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum Quotient/Remainder Case (65535 / 256)", test_num);
        dividend = 16'hFFFF;
        divisor  = 16'd256;
        #1;

        check_outputs(16'd255, 16'd255);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Large Prime Division (45000 / 1234)", test_num);
        dividend = 16'd45000;
        divisor  = 16'd1234;
        #1;

        check_outputs(16'd36, 16'd576);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Odd Number Division (65535 / 2)", test_num);
        dividend = 16'hFFFF;
        divisor  = 16'd2;
        #1;

        check_outputs(16'd32767, 16'd1);
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
        input [15:0] expected_remainder;
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
