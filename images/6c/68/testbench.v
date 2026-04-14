`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dividend;
    reg [7:0] divisor;
    reg start;
    wire done;
    wire [7:0] quotient;
    wire [7:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dividend(dividend),
        .divisor(divisor),
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
            start = 0;
            dividend = 0;
            divisor = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task run_division;

        input [7:0] in_dividend;
        input [7:0] in_divisor;
        input [7:0] exp_quotient;
        input [7:0] exp_remainder;
        begin
            test_num = test_num + 1;
            $display("Test %0d: %d / %d", test_num, in_dividend, in_divisor);

            dividend = in_dividend;
            divisor = in_divisor;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            fork : wait_done
                begin
                    wait(done);
                    disable wait_done;
                end
                begin
                    #10000;
                    $display("Error: Done signal timed out for test %0d", test_num);
                    disable wait_done;
                end
            join


            #1;



            check_outputs(1'b1, exp_quotient, exp_remainder);
            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            run_division(8'd20, 8'd5, 8'd4, 8'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            run_division(8'd17, 8'd3, 8'd5, 8'd2);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            run_division(8'd5, 8'd12, 8'd0, 8'd5);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            run_division(8'd100, 8'd1, 8'd100, 8'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            run_division(8'd42, 8'd42, 8'd1, 8'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            run_division(8'd255, 8'd255, 8'd1, 8'd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            run_division(8'd255, 8'd2, 8'd127, 8'd1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            run_division(8'd0, 8'd10, 8'd0, 8'd0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            run_division(8'd255, 8'd1, 8'd255, 8'd0);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            run_division(8'd251, 8'd13, 8'd19, 8'd4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [7:0] expected_quotient;
        input [7:0] expected_remainder;
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
        $dumpvars(0,clk, dividend, divisor, start, done, quotient, remainder);
    end

endmodule
