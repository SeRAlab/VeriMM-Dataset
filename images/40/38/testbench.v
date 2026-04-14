`timescale 1ns/1ps

module srt_divider_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] denominator;
    reg [3:0] numerator;
    wire [3:0] quotient;
    wire remainder;

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
        test_num = 1;
        $display("Test %03d: Division 8 / 2", test_num);
        numerator = 4'd8; denominator = 4'd2;
        #10;
        #1;

        check_outputs(4'd4, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %03d: Division 7 / 3", test_num);
        numerator = 4'd7; denominator = 4'd3;
        #10;
        #1;

        check_outputs(4'd2, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %03d: Small Numerator 3 / 5", test_num);
        numerator = 4'd3; denominator = 4'd5;
        #10;
        #1;

        check_outputs(4'd0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %03d: Max Numerator 15 / 1", test_num);
        numerator = 4'd15; denominator = 4'd1;
        #10;
        #1;

        check_outputs(4'd15, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %03d: Remainder LSB check 10 / 4", test_num);
        numerator = 4'd10; denominator = 4'd4;
        #10;
        #1;

        check_outputs(4'd2, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %03d: Division by self 9 / 9", test_num);
        numerator = 4'd9; denominator = 4'd9;
        #10;
        #1;

        check_outputs(4'd1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %03d: Zero numerator 0 / 7", test_num);
        numerator = 4'd0; denominator = 4'd7;
        #10;
        #1;

        check_outputs(4'd0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %03d: High bit quotient 13 / 2", test_num);
        numerator = 4'd13; denominator = 4'd2;
        #10;
        #1;

        check_outputs(4'd6, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %03d: Prime division 11 / 3", test_num);
        numerator = 4'd11; denominator = 4'd3;
        #10;
        #1;

        check_outputs(4'd3, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %03d: 15 / 4", test_num);
        numerator = 4'd15; denominator = 4'd4;
        #10;
        #1;

        check_outputs(4'd3, 1'b1);
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
        input [3:0] expected_quotient;
        input expected_remainder;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h, remainder=%b",
                         quotient, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h, remainder=%b",
                         expected_quotient, expected_remainder);
                $display("  Got:      quotient=%h, remainder=%b",
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
