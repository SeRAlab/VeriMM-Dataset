`timescale 1ns/1ps

module SRT_Divider_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] dividend;
    reg [3:0] divisor;
    reg start;
    wire [3:0] quotient;
    wire [3:0] remainder;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRT_Divider dut (
        .dividend(dividend),
        .divisor(divisor),
        .start(start),
        .quotient(quotient),
        .remainder(remainder),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Division (10 / 3)", test_num);
            start = 0; dividend = 4'd10; divisor = 4'd3;
            #10;
            start = 1;
            wait(valid === 1'b1);
            #1;

            check_outputs(4'd3, 4'd1, 1'b1);
            start = 0;
            #10;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Exact Division (12 / 4)", test_num);
            start = 0; dividend = 4'd12; divisor = 4'd4;
            #10;
            start = 1;
            wait(valid === 1'b1);
            #1;

            check_outputs(4'd3, 4'd0, 1'b1);
            start = 0;
            #10;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division by Zero (5 / 0)", test_num);
            start = 0; dividend = 4'd5; divisor = 4'd0;
            #10;
            start = 1;
            wait(valid === 1'b1);
            #1;

            check_outputs(4'hf, 4'hf, 1'b1);
            start = 0;
            #10;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dividend Smaller Than Divisor (2 / 5)", test_num);
            start = 0; dividend = 4'd2; divisor = 4'd5;
            #10;
            start = 1;
            wait(valid === 1'b1);
            #1;

            check_outputs(4'd0, 4'd2, 1'b1);
            start = 0;
            #10;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Dividend by Min Divisor (15 / 1)", test_num);
            start = 0; dividend = 4'd15; divisor = 4'd1;
            #10;
            start = 1;
            wait(valid === 1'b1);
            #1;

            check_outputs(4'd15, 4'd0, 1'b1);
            start = 0;
            #10;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Dividend (0 / 7)", test_num);
            start = 0; dividend = 4'd0; divisor = 4'd7;
            #10;
            start = 1;
            wait(valid === 1'b1);
            #1;

            check_outputs(4'd0, 4'd0, 1'b1);
            start = 0;
            #10;
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Dividend by Max Divisor (15 / 15)", test_num);
            start = 0; dividend = 4'd15; divisor = 4'd15;
            #10;
            start = 1;
            wait(valid === 1'b1);
            #1;

            check_outputs(4'd1, 4'd0, 1'b1);
            start = 0;
            #10;
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division with Remainder (7 / 2)", test_num);
            start = 0; dividend = 4'd7; divisor = 4'd2;
            #10;
            start = 1;
            wait(valid === 1'b1);
            #1;

            check_outputs(4'd3, 4'd1, 1'b1);
            start = 0;
            #10;
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Dividend with Remainder (13 / 3)", test_num);
            start = 0; dividend = 4'd13; divisor = 4'd3;
            #10;
            start = 1;
            wait(valid === 1'b1);
            #1;

            check_outputs(4'd4, 4'd1, 1'b1);
            start = 0;
            #10;
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero divided by Zero", test_num);
            start = 0; dividend = 4'd0; divisor = 4'd0;
            #10;
            start = 1;
            wait(valid === 1'b1);
            #1;

            check_outputs(4'hf, 4'hf, 1'b1);
            start = 0;
            #10;
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
        input [3:0] expected_quotient;
        input [3:0] expected_remainder;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h, remainder=%h, valid=%b",
                         quotient, remainder, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h, remainder=%h, valid=%b",
                         expected_quotient, expected_remainder, expected_valid);
                $display("  Got:      quotient=%h, remainder=%h, valid=%b",
                         quotient, remainder, valid);
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
