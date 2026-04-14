`timescale 1ns/1ps

module srt_divider_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] denominator;
    reg [15:0] numerator;
    wire [15:0] quotient;
    wire [15:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    srt_divider dut (
        .denominator(denominator),
        .numerator(numerator),
        .quotient(quotient),
        .remainder(remainder)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Division by Zero", test_num);
        numerator = 16'h1234;
        denominator = 16'h0000;
        #1;

        check_outputs(16'hFFFF, 16'hFFFF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple Division (no remainder)", test_num);
        numerator = 16'd100;
        denominator = 16'd10;
        #1;

        check_outputs(16'd10, 16'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple Division (with remainder)", test_num);
        numerator = 16'd20;
        denominator = 16'd3;
        #1;

        check_outputs(16'd6, 16'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Numerator < Denominator", test_num);
        numerator = 16'd5;
        denominator = 16'd12;
        #1;

        check_outputs(16'd0, 16'd5);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Division by 1", test_num);
        numerator = 16'hABCD;
        denominator = 16'h0001;
        #1;

        check_outputs(16'hABCD, 16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Numerator == Denominator", test_num);
        numerator = 16'h1234;
        denominator = 16'h1234;
        #1;

        check_outputs(16'h0001, 16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero Numerator", test_num);
        numerator = 16'h0000;
        denominator = 16'h5555;
        #1;

        check_outputs(16'h0000, 16'h0000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Large number division", test_num);
        numerator = 16'hABCD;
        denominator = 16'h0123;

        #1;


        check_outputs(16'h0097, 16'h0028);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max values division", test_num);
        numerator = 16'hFFFF;
        denominator = 16'h0002;

        #1;


        check_outputs(16'h7FFF, 16'h0001);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Power of 2 division", test_num);
        numerator = 16'h8000;
        denominator = 16'h0100;
        #1;

        check_outputs(16'h0080, 16'h0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("srt_divider Testbench");
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
