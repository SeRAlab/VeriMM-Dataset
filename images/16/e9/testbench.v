`timescale 1ns/1ps

module SRT_Divider_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] dividend;
    reg [7:0] divisor;
    wire [15:0] quotient;
    wire [15:0] remainder;

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
            $display("Test %0d: Basic Division (100 / 10)", test_num);
            dividend = 16'd100;
            divisor  = 8'd10;
            #1;

            check_outputs(16'd10, 16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dividend smaller than divisor (5 / 10)", test_num);
            dividend = 16'd5;
            divisor  = 8'd10;
            #1;

            check_outputs(16'd0, 16'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Exact division (255 / 5)", test_num);
            dividend = 16'd255;
            divisor  = 8'd5;
            #1;

            check_outputs(16'd51, 16'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max dividend, small divisor (65535 / 2)", test_num);
            dividend = 16'hFFFF;
            divisor  = 8'd2;
            #1;

            check_outputs(16'd32767, 16'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dividend equals divisor (128 / 128)", test_num);
            dividend = 16'd128;
            divisor  = 8'd128;
            #1;

            check_outputs(16'd1, 16'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division by 1 (1024 / 1)", test_num);
            dividend = 16'd1024;
            divisor  = 8'd1;
            #1;

            check_outputs(16'd1024, 16'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division with remainder (12345 / 7)", test_num);
            dividend = 16'd12345;
            divisor  = 8'd7;
            #1;

            check_outputs(16'd1763, 16'd4);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dividend is zero (0 / 50)", test_num);
            dividend = 16'd0;
            divisor  = 8'd50;
            #1;

            check_outputs(16'd0, 16'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division by max divisor (60000 / 255)", test_num);
            dividend = 16'd60000;
            divisor  = 8'hFF;
            #1;

            check_outputs(16'd235, 16'd75);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Power of two division (40000 / 100)", test_num);
            dividend = 16'd40000;
            divisor  = 8'd100;
            #1;

            check_outputs(16'd400, 16'd0);
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
