`timescale 1ns/1ps

module non_restoring_divider_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] dividend;
    reg [7:0] divisor;
    wire [7:0] quotient;
    wire [7:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    non_restoring_divider dut (
        .dividend(dividend),
        .divisor(divisor),
        .quotient(quotient),
        .remainder(remainder)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Division (10 / 3)", test_num);
            dividend = 8'd10;
            divisor = 8'd3;
            #1;

            check_outputs(8'd3, 8'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Divide by 1", test_num);
            dividend = 8'd42;
            divisor = 8'd1;
            #1;

            check_outputs(8'd42, 8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Dividend < Divisor", test_num);
            dividend = 8'd5;
            divisor = 8'd12;
            #1;

            check_outputs(8'd0, 8'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Divide by Self", test_num);
            dividend = 8'd128;
            divisor = 8'd128;
            #1;

            check_outputs(8'd1, 8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Dividend", test_num);
            dividend = 8'd0;
            divisor = 8'd25;
            #1;

            check_outputs(8'd0, 8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Dividend with Remainder", test_num);
            dividend = 8'd255;
            divisor = 8'd2;
            #1;

            check_outputs(8'd127, 8'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Typical Division (100 / 7)", test_num);
            dividend = 8'd100;
            divisor = 8'd7;
            #1;

            check_outputs(8'd14, 8'd2);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Result (255 / 1)", test_num);
            dividend = 8'd255;
            divisor = 8'd1;
            #1;

            check_outputs(8'd255, 8'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Divisor (200 / 150)", test_num);
            dividend = 8'd200;
            divisor = 8'd150;
            #1;

            check_outputs(8'd1, 8'd50);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power of 2 Division (64 / 8)", test_num);
            dividend = 8'd64;
            divisor = 8'd8;
            #1;

            check_outputs(8'd8, 8'd0);
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
