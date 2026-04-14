`timescale 1ns/1ps

module restoring_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] dividend;
    reg [15:0] divisor;
    reg reset;
    wire done;
    wire [15:0] quotient;
    wire [15:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    restoring_divider dut (
        .clk(clk),
        .dividend(dividend),
        .divisor(divisor),
        .reset(reset),
        .done(done),
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
            reset = 1;
            dividend = 0;
            divisor = 0;
            @(posedge clk);
            #2 reset = 0;

            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Division (20 / 4)", test_num);
            reset_dut();
            dividend = 16'd20;
            divisor = 16'd4;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd5, 16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Division with Remainder (21 / 4)", test_num);
            reset_dut();
            dividend = 16'd21;
            divisor = 16'd4;
            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd5, 16'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dividend < Divisor (5 / 10)", test_num);
            reset_dut();
            dividend = 16'd5;
            divisor = 16'd10;
            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd0, 16'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large Numbers (65535 / 255)", test_num);
            reset_dut();
            dividend = 16'hFFFF;
            divisor = 16'd255;
            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd257, 16'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Dividend (0 / 50)", test_num);
            reset_dut();
            dividend = 16'd0;
            divisor = 16'd50;
            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd0, 16'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Division by 1 (1234 / 1)", test_num);
            reset_dut();
            dividend = 16'd1234;
            divisor = 16'd1;
            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd1234, 16'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Dividend / 2 (65535 / 2)", test_num);
            reset_dut();
            dividend = 16'hFFFF;
            divisor = 16'd2;
            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd32767, 16'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random Large Values (54321 / 123)", test_num);
            reset_dut();
            dividend = 16'd54321;
            divisor = 16'd123;
            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 16'd441, 16'd78);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power of 2 (1024 / 32)", test_num);
            reset_dut();
            dividend = 16'd1024;
            divisor = 16'd32;
            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd32, 16'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Equal Dividend and Divisor (123 / 123)", test_num);
            reset_dut();
            dividend = 16'd123;
            divisor = 16'd123;
            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd1, 16'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("restoring_divider Testbench");
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
        input expected_done;
        input [15:0] expected_quotient;
        input [15:0] expected_remainder;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: done=%b, quotient=%h, remainder=%h",
                         done, quotient, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, quotient=%h, remainder=%h",
                         expected_done, expected_quotient, expected_remainder);
                $display("  Got:      done=%b, quotient=%h, remainder=%h",
                         done, quotient, remainder);
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
        $dumpvars(0,clk, dividend, divisor, reset, done, quotient, remainder);
    end

endmodule
