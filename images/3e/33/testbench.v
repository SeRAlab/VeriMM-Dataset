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
        $display("\nTest %0d: Basic Division (100 / 10)", test_num);
        dividend = 16'd100;
        divisor = 16'd10;
        #1;

        check_outputs(16'd10, 16'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Division with Remainder (100 / 3)", test_num);
        dividend = 16'd100;
        divisor = 16'd3;
        #1;

        check_outputs(16'd33, 16'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Dividend < Divisor (5 / 12)", test_num);
        dividend = 16'd5;
        divisor = 16'd12;
        #1;

        check_outputs(16'd0, 16'd5);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Dividend is Zero (0 / 50)", test_num);
        dividend = 16'd0;
        divisor = 16'd50;
        #1;

        check_outputs(16'd0, 16'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Division by One (500 / 1)", test_num);
        dividend = 16'd500;
        divisor = 16'd1;
        #1;

        check_outputs(16'd500, 16'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Dividend equals Divisor (1024 / 1024)", test_num);
        dividend = 16'd1024;
        divisor = 16'd1024;
        #1;

        check_outputs(16'd1, 16'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Large Dividend (65535 / 2)", test_num);
        dividend = 16'hFFFF;
        divisor = 16'd2;
        #1;

        check_outputs(16'h7FFF, 16'h0001);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Maximum Divisor (65535 / 65535)", test_num);
        dividend = 16'hFFFF;
        divisor = 16'hFFFF;
        #1;

        check_outputs(16'h0001, 16'h0000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Power of Two Division (4096 / 64)", test_num);
        dividend = 16'd4096;
        divisor = 16'd64;
        #1;

        check_outputs(16'd64, 16'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Prime Number Division (12345 / 7)", test_num);
        dividend = 16'd12345;
        divisor = 16'd7;

        #1;


        check_outputs(16'd1763, 16'd4);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: High Bit Dividend (32768 / 128)", test_num);
        dividend = 16'h8000;
        divisor = 16'd128;
        #1;

        check_outputs(16'd256, 16'd0);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Complex Remainder (10000 / 123)", test_num);
        dividend = 16'd10000;
        divisor = 16'd123;

        #1;


        check_outputs(16'd81, 16'd37);
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
