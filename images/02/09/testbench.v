`timescale 1ns/1ps

module restoring_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] dividend;
    reg [2:0] divisor;
    reg reset;
    reg start;
    wire done;
    wire [4:0] quotient;
    wire [1:0] remainder;

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
            reset = 1;
            start = 0;
            dividend = 5'd0;
            divisor = 3'd0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: 10 / 2");
            reset_dut();
            dividend = 5'd10;
            divisor = 3'd2;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 5'd5, 2'd0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: 15 / 4");
            reset_dut();
            dividend = 5'd15;
            divisor = 3'd4;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 5'd3, 2'd3);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: 2 / 5");
            reset_dut();
            dividend = 5'd2;
            divisor = 3'd5;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 5'd0, 2'd2);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: 31 / 1");
            reset_dut();
            dividend = 5'd31;
            divisor = 3'd1;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 5'd31, 2'd0);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: 0 / 3");
            reset_dut();
            dividend = 5'd0;
            divisor = 3'd3;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 5'd0, 2'd0);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: 6 / 6");
            reset_dut();
            dividend = 5'd6;
            divisor = 3'd6;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 5'd1, 2'd0);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: 19 / 4");
            reset_dut();
            dividend = 5'd19;
            divisor = 3'd4;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 5'd4, 2'd3);
        end
        endtask

    task testcase008;

        begin
            $display("\nTestcase 008: 26 / 6");
            reset_dut();
            dividend = 5'd26;
            divisor = 3'd6;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(done);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 5'd4, 2'd2);
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
        input [4:0] expected_quotient;
        input [1:0] expected_remainder;
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
        $dumpvars(0,clk, dividend, divisor, reset, start, done, quotient, remainder);
    end

endmodule
