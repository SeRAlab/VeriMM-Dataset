`timescale 1ns/1ps

module divider_2bit_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] dividend;
    reg [1:0] divisor;
    wire error;
    wire [1:0] quotient;
    wire [1:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divider_2bit dut (
        .dividend(dividend),
        .divisor(divisor),
        .error(error),
        .quotient(quotient),
        .remainder(remainder)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Division by Zero", test_num);


            dividend = 2'b00; divisor = 2'b00;
            #1;

            check_outputs(1'b1, 2'b00, 2'b00);


            dividend = 2'b01; divisor = 2'b00;
            #1;

            check_outputs(1'b1, 2'b00, 2'b00);


            dividend = 2'b10; divisor = 2'b00;
            #1;

            check_outputs(1'b1, 2'b00, 2'b00);


            dividend = 2'b11; divisor = 2'b00;
            #1;

            check_outputs(1'b1, 2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Dividend is Zero (0 / N)", test_num);


            dividend = 2'b00; divisor = 2'b01;
            #1;

            check_outputs(1'b0, 2'b00, 2'b00);


            dividend = 2'b00; divisor = 2'b10;
            #1;

            check_outputs(1'b0, 2'b00, 2'b00);


            dividend = 2'b00; divisor = 2'b11;
            #1;

            check_outputs(1'b0, 2'b00, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Dividend < Divisor", test_num);


            dividend = 2'b01; divisor = 2'b10;
            #1;

            check_outputs(1'b0, 2'b00, 2'b01);


            dividend = 2'b01; divisor = 2'b11;
            #1;

            check_outputs(1'b0, 2'b00, 2'b01);


            dividend = 2'b10; divisor = 2'b11;
            #1;

            check_outputs(1'b0, 2'b00, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Dividend == Divisor", test_num);


            dividend = 2'b01; divisor = 2'b01;
            #1;

            check_outputs(1'b0, 2'b01, 2'b00);


            dividend = 2'b10; divisor = 2'b10;
            #1;

            check_outputs(1'b0, 2'b01, 2'b00);


            dividend = 2'b11; divisor = 2'b11;
            #1;

            check_outputs(1'b0, 2'b01, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Dividend > Divisor", test_num);


            dividend = 2'b10; divisor = 2'b01;
            #1;

            check_outputs(1'b0, 2'b10, 2'b00);


            dividend = 2'b11; divisor = 2'b01;
            #1;

            check_outputs(1'b0, 2'b11, 2'b00);


            dividend = 2'b11; divisor = 2'b10;
            #1;

            check_outputs(1'b0, 2'b01, 2'b01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("divider_2bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_error;
        input [1:0] expected_quotient;
        input [1:0] expected_remainder;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_error === (expected_error ^ error ^ expected_error) &&
                expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: error=%b, quotient=%h, remainder=%h",
                         error, quotient, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error=%b, quotient=%h, remainder=%h",
                         expected_error, expected_quotient, expected_remainder);
                $display("  Got:      error=%b, quotient=%h, remainder=%h",
                         error, quotient, remainder);
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
