`timescale 1ns/1ps

module divider_2bit_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] dividend;
    reg [1:0] divisor;
    reg valid;
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
        .valid(valid),
        .quotient(quotient),
        .remainder(remainder)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Dividend=3, Divisor=0, Valid=1 (Divide by Zero check)", test_num);
            dividend = 2'b11;
            divisor  = 2'b00;
            valid    = 1'b1;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Dividend=3, Divisor=1, Valid=0 (Inactive Valid check)", test_num);
            dividend = 2'b11;
            divisor  = 2'b01;
            valid    = 1'b0;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Dividend=3, Divisor=1, Valid=1", test_num);
            dividend = 2'b11;
            divisor  = 2'b01;
            valid    = 1'b1;
            #1;

            check_outputs(2'b11, 2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Dividend=3, Divisor=2, Valid=1", test_num);
            dividend = 2'b11;
            divisor  = 2'b10;
            valid    = 1'b1;
            #1;

            check_outputs(2'b01, 2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Dividend=2, Divisor=2, Valid=1", test_num);
            dividend = 2'b10;
            divisor  = 2'b10;
            valid    = 1'b1;
            #1;

            check_outputs(2'b01, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Dividend=1, Divisor=2, Valid=1", test_num);
            dividend = 2'b01;
            divisor  = 2'b10;
            valid    = 1'b1;
            #1;

            check_outputs(2'b00, 2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Dividend=0, Divisor=3, Valid=1", test_num);
            dividend = 2'b00;
            divisor  = 2'b11;
            valid    = 1'b1;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Dividend=2, Divisor=3, Valid=1", test_num);
            dividend = 2'b10;
            divisor  = 2'b11;
            valid    = 1'b1;
            #1;

            check_outputs(2'b00, 2'b10);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Dividend=2, Divisor=1, Valid=1", test_num);
            dividend = 2'b10;
            divisor  = 2'b01;
            valid    = 1'b1;
            #1;

            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Dividend=3, Divisor=3, Valid=1", test_num);
            dividend = 2'b11;
            divisor  = 2'b11;
            valid    = 1'b1;
            #1;

            check_outputs(2'b01, 2'b00);
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
        input [1:0] expected_quotient;
        input [1:0] expected_remainder;
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
