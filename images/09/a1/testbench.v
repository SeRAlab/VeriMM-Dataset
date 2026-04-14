`timescale 1ns/1ps

module SRT_Divider_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] dividend;
    reg [4:0] divisor;
    wire [4:0] quotient;
    wire [4:0] remainder;

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
        $display("Testcase %03d: Division by Zero (25 / 0)", test_num);
        dividend = 5'd25;
        divisor = 5'd0;
        #1;

        check_outputs(5'd0, 5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Zero Dividend (0 / 10)", test_num);
        dividend = 5'd0;
        divisor = 5'd10;
        #1;

        check_outputs(5'd0, 5'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Identity Division (1 / 1)", test_num);
        dividend = 5'd1;
        divisor = 5'd1;
        #1;

        check_outputs(5'd1, 5'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Exact Division (15 / 3)", test_num);
        dividend = 5'd15;
        divisor = 5'd3;
        #1;

        check_outputs(5'd5, 5'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Division with Remainder (17 / 3)", test_num);
        dividend = 5'd17;
        divisor = 5'd3;
        #1;

        check_outputs(5'd5, 5'd2);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Dividend Smaller Than Divisor (5 / 12)", test_num);
        dividend = 5'd5;
        divisor = 5'd12;
        #1;

        check_outputs(5'd0, 5'd5);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Max Dividend by Max Divisor (31 / 31)", test_num);
        dividend = 5'd31;
        divisor = 5'd31;
        #1;

        check_outputs(5'd1, 5'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Max Dividend by 1 (31 / 1)", test_num);
        dividend = 5'd31;
        divisor = 5'd1;
        #1;

        check_outputs(5'd31, 5'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Max Dividend with Remainder (31 / 4)", test_num);
        dividend = 5'd31;
        divisor = 5'd4;
        #1;

        check_outputs(5'd7, 5'd3);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Power of Two Division (16 / 4)", test_num);
        dividend = 5'd16;
        divisor = 5'd4;
        #1;

        check_outputs(5'd4, 5'd0);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Prime Division (29 / 7)", test_num);
        dividend = 5'd29;
        divisor = 5'd7;
        #1;

        check_outputs(5'd4, 5'd1);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Large Remainder (23 / 12)", test_num);
        dividend = 5'd23;
        divisor = 5'd12;
        #1;

        check_outputs(5'd1, 5'd11);
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
        input [4:0] expected_remainder;
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
