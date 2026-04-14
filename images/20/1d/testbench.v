`timescale 1ns/1ps

module SRT_divider_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] denominator;
    reg [7:0] numerator;
    wire [7:0] quotient;
    wire [7:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRT_divider dut (
        .denominator(denominator),
        .numerator(numerator),
        .quotient(quotient),
        .remainder(remainder)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Basic Division (No Remainder)", test_num);
        numerator = 8'd20;
        denominator = 8'd4;
        #1;

        check_outputs(8'd5, 8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Basic Division (With Remainder)", test_num);
        numerator = 8'd20;
        denominator = 8'd3;
        #1;

        check_outputs(8'd6, 8'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Division by 1", test_num);
        numerator = 8'd255;
        denominator = 8'd1;
        #1;

        check_outputs(8'd255, 8'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Zero Numerator", test_num);
        numerator = 8'd0;
        denominator = 8'd10;
        #1;

        check_outputs(8'd0, 8'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Numerator < Denominator", test_num);
        numerator = 8'd5;
        denominator = 8'd12;
        #1;

        check_outputs(8'd0, 8'd5);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Numerator == Denominator", test_num);
        numerator = 8'd128;
        denominator = 8'd128;
        #1;

        check_outputs(8'd1, 8'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Maximum Numerator", test_num);
        numerator = 8'd255;
        denominator = 8'd2;
        #1;

        check_outputs(8'd127, 8'd1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Power of 2 Division", test_num);
        numerator = 8'd64;
        denominator = 8'd8;
        #1;

        check_outputs(8'd8, 8'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Large Remainder", test_num);
        numerator = 8'd127;
        denominator = 8'd64;
        #1;

        check_outputs(8'd1, 8'd63);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Prime Number Division", test_num);
        numerator = 8'd100;
        denominator = 8'd7;
        #1;

        check_outputs(8'd14, 8'd2);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %0d: Boundary Case (Nearly Max)", test_num);
        numerator = 8'd254;
        denominator = 8'd127;
        #1;

        check_outputs(8'd2, 8'd0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Testcase %0d: Random Dense Division", test_num);
        numerator = 8'd173;
        denominator = 8'd13;
        #1;

        check_outputs(8'd13, 8'd4);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRT_divider Testbench");
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
        input [7:0] expected_quotient;
        input [7:0] expected_remainder;
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
