`timescale 1ns/1ps

module non_restoring_divider_tb;

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
    non_restoring_divider dut (
        .dividend(dividend),
        .divisor(divisor),
        .start(start),
        .quotient(quotient),
        .remainder(remainder),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic exact division (12 / 3)", test_num);
            dividend = 4'd12;
            divisor = 4'd3;
            start = 1'b1;
            #20;
            #1;

            check_outputs(4'd4, 4'd0, 1'b1);
            start = 1'b0;
            #10;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Division with remainder (14 / 4)", test_num);
            dividend = 4'd14;
            divisor = 4'd4;
            start = 1'b1;
            #20;
            #1;

            check_outputs(4'd3, 4'd2, 1'b1);
            start = 1'b0;
            #10;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Dividend smaller than divisor (3 / 7)", test_num);
            dividend = 4'd3;
            divisor = 4'd7;
            start = 1'b1;
            #20;
            #1;

            check_outputs(4'd0, 4'd3, 1'b1);
            start = 1'b0;
            #10;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Division by zero handling", test_num);
            dividend = 4'd10;
            divisor = 4'd0;
            start = 1'b1;
            #20;

            #1;


            check_outputs(quotient, remainder, 1'b0);
            start = 1'b0;
            #10;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Zero dividend (0 / 5)", test_num);
            dividend = 4'd0;
            divisor = 4'd5;
            start = 1'b1;
            #20;
            #1;

            check_outputs(4'd0, 4'd0, 1'b1);
            start = 1'b0;
            #10;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Max values (15 / 1)", test_num);
            dividend = 4'd15;
            divisor = 4'd1;
            start = 1'b1;
            #20;
            #1;

            check_outputs(4'd15, 4'd0, 1'b1);
            start = 1'b0;
            #10;
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Max dividend / Max divisor (15 / 15)", test_num);
            dividend = 4'd15;
            divisor = 4'd15;
            start = 1'b1;
            #20;
            #1;

            check_outputs(4'd1, 4'd0, 1'b1);
            start = 1'b0;
            #10;
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Prime number division (13 / 5)", test_num);
            dividend = 4'd13;
            divisor = 4'd5;
            start = 1'b1;
            #20;
            #1;

            check_outputs(4'd2, 4'd3, 1'b1);
            start = 1'b0;
            #10;
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Large remainder (11 / 6)", test_num);
            dividend = 4'd11;
            divisor = 4'd6;
            start = 1'b1;
            #20;
            #1;

            check_outputs(4'd1, 4'd5, 1'b1);
            start = 1'b0;
            #10;
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Dividend is 1 (1 / 2)", test_num);
            dividend = 4'd1;
            divisor = 4'd2;
            start = 1'b1;
            #20;
            #1;

            check_outputs(4'd0, 4'd1, 1'b1);
            start = 1'b0;
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
        $display("non_restoring_divider Testbench");
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
