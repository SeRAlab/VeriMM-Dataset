`timescale 1ns/1ps

module restoring_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [5:0] dividend;
    reg [2:0] divisor;
    reg rst;
    reg start;
    wire done;
    wire [5:0] quotient;
    wire [5:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    restoring_divider dut (
        .clk(clk),
        .dividend(dividend),
        .divisor(divisor),
        .rst(rst),
        .start(start),
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
            rst = 1;
            start = 0;
            dividend = 0;
            divisor = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task run_division;

        input [5:0] in_dividend;
        input [2:0] in_divisor;
        begin
            @(posedge clk);
            dividend = in_dividend;
            divisor = in_divisor;
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done == 1);
            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 15 / 3", test_num);
            reset_dut();
            run_division(6'd15, 3'd3);
            #1;

            check_outputs(1'b1, 6'd5, 6'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 20 / 7", test_num);
            reset_dut();
            run_division(6'd20, 3'd7);
            #1;

            check_outputs(1'b1, 6'd2, 6'd6);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 2 / 5", test_num);
            reset_dut();
            run_division(6'd2, 3'd5);
            #1;

            check_outputs(1'b1, 6'd0, 6'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 63 / 7", test_num);
            reset_dut();
            run_division(6'd63, 3'd7);
            #1;

            check_outputs(1'b1, 6'd9, 6'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 0 / 3", test_num);
            reset_dut();
            run_division(6'd0, 3'd3);
            #1;

            check_outputs(1'b1, 6'd0, 6'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 31 / 1", test_num);
            reset_dut();
            run_division(6'd31, 3'd1);
            #1;

            check_outputs(1'b1, 6'd31, 6'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 63 / 1", test_num);
            reset_dut();
            run_division(6'd63, 3'd1);
            #1;

            check_outputs(1'b1, 6'd63, 6'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 43 / 6", test_num);
            reset_dut();
            run_division(6'd43, 3'd6);
            #1;

            check_outputs(1'b1, 6'd7, 6'd1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 50 / 4", test_num);
            reset_dut();
            run_division(6'd50, 3'd4);
            #1;

            check_outputs(1'b1, 6'd12, 6'd2);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 5 / 5", test_num);
            reset_dut();
            run_division(6'd5, 3'd5);
            #1;

            check_outputs(1'b1, 6'd1, 6'd0);
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
        input [5:0] expected_quotient;
        input [5:0] expected_remainder;
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
        $dumpvars(0,clk, dividend, divisor, rst, start, done, quotient, remainder);
    end

endmodule
