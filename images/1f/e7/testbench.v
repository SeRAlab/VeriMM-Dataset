`timescale 1ns/1ps

module adaptive_lms_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg rst;
    reg [15:0] x;
    wire [15:0] w0;
    wire [15:0] w1;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adaptive_lms dut (
        .clk(clk),
        .d(d),
        .rst(rst),
        .x(x),
        .w0(w0),
        .w1(w1),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        x = 16'h0000;
        d = 16'h0000;
        @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Resetting DUT and checking initial state...");
        reset_dut();

        #1;


        check_outputs(16'h0000, 16'h0000, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Zero input signal, non-zero desired...");
        reset_dut();
        x = 16'h0000;
        d = 16'h4000;
        repeat(10) @(posedge clk);
        #1;

        #1;


        check_outputs(16'h0000, 16'h0000, 16'h0000);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Simple weight adaptation (x=d)...");
        reset_dut();
        x = 16'h2000;
        d = 16'h2000;

        repeat(20) @(posedge clk);
        #1;



        if (w0 > 16'h0000 && y > 16'h0000) begin
            $display("PASS: Filter is adapting weights upwards.");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: Filter weights did not adapt.");
            fail_count = fail_count + 1;
        end
    end
        endtask

    task testcase004;

    reg [15:0] history;
    begin
        $display("Testcase 004: Adaptation to delayed signal...");
        reset_dut();

        repeat(50) begin
            history = x;
            x = $random % 16'h2000;
            d = history;
            @(posedge clk);
        end
        #1;

        if (w1 > w0) begin
            $display("PASS: w1 evolved to handle delay.");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: w1 did not adapt correctly to delayed signal.");
            fail_count = fail_count + 1;
        end
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Convergence check...");
        reset_dut();
        x = 16'h1000;
        d = 16'h3000;
        repeat(100) @(posedge clk);
        #1;


        if (y > 16'h2F00 && y < 16'h3100) begin
            $display("PASS: Filter converged close to desired d.");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: Filter failed to converge. Got y=%h, expected approx %h", y, d);
            fail_count = fail_count + 1;
        end
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adaptive_lms Testbench");
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
        input [15:0] expected_w0;
        input [15:0] expected_w1;
        input [15:0] expected_y;
        begin
            if (expected_w0 === (expected_w0 ^ w0 ^ expected_w0) &&
                expected_w1 === (expected_w1 ^ w1 ^ expected_w1) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: w0=%h, w1=%h, y=%h",
                         w0, w1, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w0=%h, w1=%h, y=%h",
                         expected_w0, expected_w1, expected_y);
                $display("  Got:      w0=%h, w1=%h, y=%h",
                         w0, w1, y);
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
        $dumpvars(0,clk, d, rst, x, w0, w1, y);
    end

endmodule
