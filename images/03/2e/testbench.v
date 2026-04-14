`timescale 1ns/1ps

module fft_4point_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] x0;
    reg [7:0] x1;
    reg [7:0] x2;
    reg [7:0] x3;
    wire [7:0] y0;
    wire [7:0] y1;
    wire [7:0] y2;
    wire [7:0] y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_4point dut (
        .clk(clk),
        .reset(reset),
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .y0(y0),
        .y1(y1),
        .y2(y2),
        .y3(y3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            x0 = 0; x1 = 0; x2 = 0; x3 = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: All Zeros");
            reset_dut();
            x0 = 8'h00; x1 = 8'h00; x2 = 8'h00; x3 = 8'h00;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: DC Signal (15, 15, 15, 15)");
            reset_dut();
            x0 = 8'd15; x1 = 8'd15; x2 = 8'd15; x3 = 8'd15;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h3C, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Impulse at x0 (30, 0, 0, 0)");
            reset_dut();
            x0 = 8'd30; x1 = 8'd0; x2 = 8'd0; x3 = 8'd0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h1E, 8'h1E, 8'h1E, 8'h00);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Nyquist Freq (20, -20, 20, -20)");
            reset_dut();
            x0 = 8'd20; x1 = -8'd20; x2 = 8'd20; x3 = -8'd20;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h00, 8'h00, 8'h50, 8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Complex Phase Shift (10, 10, -10, -10)");
            reset_dut();
            x0 = 8'd10; x1 = 8'd10; x2 = -8'd10; x3 = -8'd10;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h00, 8'h14, 8'h00, 8'hEC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fft_4point Testbench");
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
        input [7:0] expected_y0;
        input [7:0] expected_y1;
        input [7:0] expected_y2;
        input [7:0] expected_y3;
        begin
            if (expected_y0 === (expected_y0 ^ y0 ^ expected_y0) &&
                expected_y1 === (expected_y1 ^ y1 ^ expected_y1) &&
                expected_y2 === (expected_y2 ^ y2 ^ expected_y2) &&
                expected_y3 === (expected_y3 ^ y3 ^ expected_y3)) begin
                $display("PASS");
                $display("  Outputs: y0=%h, y1=%h, y2=%h, y3=%h",
                         y0, y1, y2, y3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y0=%h, y1=%h, y2=%h, y3=%h",
                         expected_y0, expected_y1, expected_y2, expected_y3);
                $display("  Got:      y0=%h, y1=%h, y2=%h, y3=%h",
                         y0, y1, y2, y3);
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
        $dumpvars(0,clk, reset, x0, x1, x2, x3, y0, y1, y2, y3);
    end

endmodule
