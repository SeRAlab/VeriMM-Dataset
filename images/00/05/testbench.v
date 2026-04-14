`timescale 1ns/1ps

module fft_4point_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] x0_im;
    reg [15:0] x0_re;
    reg [15:0] x1_im;
    reg [15:0] x1_re;
    reg [15:0] x2_im;
    reg [15:0] x2_re;
    reg [15:0] x3_im;
    reg [15:0] x3_re;
    wire done;
    wire [15:0] y0_im;
    wire [15:0] y0_re;
    wire [15:0] y1_im;
    wire [15:0] y1_re;
    wire [15:0] y2_im;
    wire [15:0] y2_re;
    wire [15:0] y3_im;
    wire [15:0] y3_re;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_4point dut (
        .clk(clk),
        .reset(reset),
        .x0_im(x0_im),
        .x0_re(x0_re),
        .x1_im(x1_im),
        .x1_re(x1_re),
        .x2_im(x2_im),
        .x2_re(x2_re),
        .x3_im(x3_im),
        .x3_re(x3_re),
        .done(done),
        .y0_im(y0_im),
        .y0_re(y0_re),
        .y1_im(y1_im),
        .y1_re(y1_re),
        .y2_im(y2_im),
        .y2_re(y2_re),
        .y3_im(y3_im),
        .y3_re(y3_re)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        x0_re = 0; x0_im = 0;
        x1_re = 0; x1_im = 0;
        x2_re = 0; x2_im = 0;
        x3_re = 0; x3_im = 0;
        @(posedge clk);
        #2 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Impulse Response x=[1, 0, 0, 0]", test_num);
        x0_re = 16'h0001; x0_im = 16'h0000;
        x1_re = 16'h0000; x1_im = 16'h0000;
        x2_re = 16'h0000; x2_im = 16'h0000;
        x3_re = 16'h0000; x3_im = 16'h0000;

        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1,
            16'h0000, 16'h0001,
            16'h0000, 16'h0001,
            16'h0000, 16'h0001,
            16'h0000, 16'h0001
        );
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: DC Signal x=[1, 1, 1, 1]", test_num);
        x0_re = 16'h0001; x0_im = 16'h0000;
        x1_re = 16'h0001; x1_im = 16'h0000;
        x2_re = 16'h0001; x2_im = 16'h0000;
        x3_re = 16'h0001; x3_im = 16'h0000;

        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1,
            16'h0000, 16'h0004,
            16'h0000, 16'h0000,
            16'h0000, 16'h0000,
            16'h0000, 16'h0000
        );
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Complex Sequence", test_num);
        x0_re = 16'h0001; x0_im = 16'h0001;
        x1_re = 16'h0002; x1_im = 16'h0002;
        x2_re = 16'h0003; x2_im = 16'h0003;
        x3_re = 16'h0004; x3_im = 16'h0004;

        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1,
            16'h000A, 16'h000A,
            16'h0000, 16'hFFFC,
            16'hFFFE, 16'hFFFE,
            16'hFFFC, 16'h0000
        );
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Descending Ramp", test_num);
        x0_re = 16'h0004; x0_im = 16'h0000;
        x1_re = 16'h0003; x1_im = 16'h0000;
        x2_re = 16'h0002; x2_im = 16'h0000;
        x3_re = 16'h0001; x3_im = 16'h0000;

        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1,
            16'h0000, 16'h000A,
            16'hFFFE, 16'h0002,
            16'h0000, 16'h0002,
            16'h0002, 16'h0002
        );
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Shifted Impulse x=[0, 1, 0, 0]", test_num);
        x0_re = 16'h0000; x0_im = 16'h0000;
        x1_re = 16'h0001; x1_im = 16'h0000;
        x2_re = 16'h0000; x2_im = 16'h0000;
        x3_re = 16'h0000; x3_im = 16'h0000;

        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1,
            16'h0000, 16'h0001,
            16'hFFFF, 16'h0000,
            16'h0000, 16'hFFFF,
            16'h0001, 16'h0000
        );
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
        input expected_done;
        input [15:0] expected_y0_im;
        input [15:0] expected_y0_re;
        input [15:0] expected_y1_im;
        input [15:0] expected_y1_re;
        input [15:0] expected_y2_im;
        input [15:0] expected_y2_re;
        input [15:0] expected_y3_im;
        input [15:0] expected_y3_re;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_y0_im === (expected_y0_im ^ y0_im ^ expected_y0_im) &&
                expected_y0_re === (expected_y0_re ^ y0_re ^ expected_y0_re) &&
                expected_y1_im === (expected_y1_im ^ y1_im ^ expected_y1_im) &&
                expected_y1_re === (expected_y1_re ^ y1_re ^ expected_y1_re) &&
                expected_y2_im === (expected_y2_im ^ y2_im ^ expected_y2_im) &&
                expected_y2_re === (expected_y2_re ^ y2_re ^ expected_y2_re) &&
                expected_y3_im === (expected_y3_im ^ y3_im ^ expected_y3_im) &&
                expected_y3_re === (expected_y3_re ^ y3_re ^ expected_y3_re)) begin
                $display("PASS");
                $display("  Outputs: done=%b, y0_im=%h, y0_re=%h, y1_im=%h, y1_re=%h, y2_im=%h, y2_re=%h, y3_im=%h, y3_re=%h",
                         done, y0_im, y0_re, y1_im, y1_re, y2_im, y2_re, y3_im, y3_re);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, y0_im=%h, y0_re=%h, y1_im=%h, y1_re=%h, y2_im=%h, y2_re=%h, y3_im=%h, y3_re=%h",
                         expected_done, expected_y0_im, expected_y0_re, expected_y1_im, expected_y1_re, expected_y2_im, expected_y2_re, expected_y3_im, expected_y3_re);
                $display("  Got:      done=%b, y0_im=%h, y0_re=%h, y1_im=%h, y1_re=%h, y2_im=%h, y2_re=%h, y3_im=%h, y3_re=%h",
                         done, y0_im, y0_re, y1_im, y1_re, y2_im, y2_re, y3_im, y3_re);
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
        $dumpvars(0,clk, reset, x0_im, x0_re, x1_im, x1_re, x2_im, x2_re, x3_im, x3_re, done, y0_im, y0_re, y1_im, y1_re, y2_im, y2_re, y3_im, y3_re);
    end

endmodule
