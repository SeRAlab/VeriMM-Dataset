`timescale 1ns/1ps

module divider_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dividend;
    reg [7:0] divisor;
    wire error;
    wire [7:0] quotient;
    wire [7:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divider_8bit dut (
        .clk(clk),
        .dividend(dividend),
        .divisor(divisor),
        .error(error),
        .quotient(quotient),
        .remainder(remainder)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            dividend = 0;
            divisor = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Simple division (10 / 2)", test_num);
            reset_dut();
            dividend = 8'd10;
            divisor = 8'd2;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 8'd5, 8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Division with remainder (11 / 3)", test_num);
            reset_dut();
            dividend = 8'd11;
            divisor = 8'd3;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 8'd3, 8'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Division by zero error (100 / 0)", test_num);
            reset_dut();
            dividend = 8'd100;
            divisor = 8'd0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b1, quotient, remainder);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Dividend is zero (0 / 50)", test_num);
            reset_dut();
            dividend = 8'd0;
            divisor = 8'd50;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 8'd0, 8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Dividend equals divisor (42 / 42)", test_num);
            reset_dut();
            dividend = 8'd42;
            divisor = 8'd42;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 8'd1, 8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Max dividend, min divisor (255 / 1)", test_num);
            reset_dut();
            dividend = 8'hFF;
            divisor = 8'd1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 8'd255, 8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: Max dividend, max divisor (255 / 255)", test_num);
            reset_dut();
            dividend = 8'hFF;
            divisor = 8'hFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 8'd1, 8'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest Case %0d: 255 / 2", test_num);
            reset_dut();
            dividend = 8'd255;
            divisor = 8'd2;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 8'd127, 8'd1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTest Case %0d: Divisor larger than dividend (5 / 10)", test_num);
            reset_dut();
            dividend = 8'd5;
            divisor = 8'd10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 8'd0, 8'd5);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("\nTest Case %0d: Prime number division (127 / 13)", test_num);
            reset_dut();
            dividend = 8'd127;
            divisor = 8'd13;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 8'd9, 8'd10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("divider_8bit Testbench");
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
        input expected_error;
        input [7:0] expected_quotient;
        input [7:0] expected_remainder;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, dividend, divisor, error, quotient, remainder);
    end

endmodule
