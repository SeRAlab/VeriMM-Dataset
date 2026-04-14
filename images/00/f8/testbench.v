`timescale 1ns/1ps

module divider_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] dividend;
    reg [3:0] divisor;
    wire [3:0] quotient;
    wire [3:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divider dut (
        .dividend(dividend),
        .divisor(divisor),
        .quotient(quotient),
        .remainder(remainder)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: dividend=12, divisor=3", test_num);
        dividend = 4'd12;
        divisor = 4'd3;
        #1;

        check_outputs(4'd4, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: dividend=15, divisor=4", test_num);
        dividend = 4'd15;
        divisor = 4'd4;
        #1;

        check_outputs(4'd3, 4'd3);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: dividend=2, divisor=5", test_num);
        dividend = 4'd2;
        divisor = 4'd5;
        #1;

        check_outputs(4'd0, 4'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: dividend=7, divisor=1", test_num);
        dividend = 4'd7;
        divisor = 4'd1;
        #1;

        check_outputs(4'd7, 4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: dividend=0, divisor=9", test_num);
        dividend = 4'd0;
        divisor = 4'd9;
        #1;

        check_outputs(4'd0, 4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: dividend=15, divisor=1", test_num);
        dividend = 4'd15;
        divisor = 4'd1;
        #1;

        check_outputs(4'd15, 4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: dividend=10, divisor=10", test_num);
        dividend = 4'd10;
        divisor = 4'd10;
        #1;

        check_outputs(4'd1, 4'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: dividend=11, divisor=6", test_num);
        dividend = 4'd11;
        divisor = 4'd6;
        #1;

        check_outputs(4'd1, 4'd5);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: dividend=9, divisor=5", test_num);
        dividend = 4'd9;
        divisor = 4'd5;
        #1;

        check_outputs(4'd1, 4'd4);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: dividend=15, divisor=8", test_num);
        dividend = 4'd15;
        divisor = 4'd8;
        #1;

        check_outputs(4'd1, 4'd7);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("divider Testbench");
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
