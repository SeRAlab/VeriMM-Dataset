`timescale 1ns/1ps

module fft_4point_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] x0;
    reg [15:0] x1;
    reg [15:0] x2;
    reg [15:0] x3;
    wire [15:0] im0;
    wire [15:0] im1;
    wire [15:0] im2;
    wire [15:0] im3;
    wire [15:0] re0;
    wire [15:0] re1;
    wire [15:0] re2;
    wire [15:0] re3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_4point dut (
        .clk(clk),
        .rst(rst),
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .im0(im0),
        .im1(im1),
        .im2(im2),
        .im3(im3),
        .re0(re0),
        .re1(re1),
        .re2(re2),
        .re3(re3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x0 = 0;
            x1 = 0;
            x2 = 0;
            x3 = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Unit Impulse", test_num);
            x0 = 16'h0001;
            x1 = 16'h0000;
            x2 = 16'h0000;
            x3 = 16'h0000;


            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(
                16'h0000, 16'h0000, 16'h0000, 16'h0000,
                16'h0001, 16'h0001, 16'h0001, 16'h0001
            );
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: DC Signal", test_num);
            x0 = 16'h0001;
            x1 = 16'h0001;
            x2 = 16'h0001;
            x3 = 16'h0001;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(
                16'h0000, 16'h0000, 16'h0000, 16'h0000,
                16'h0004, 16'h0000, 16'h0000, 16'h0000
            );
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: High Frequency Alternate", test_num);
            x0 = 16'h0001;
            x1 = 16'hFFFF;
            x2 = 16'h0001;
            x3 = 16'hFFFF;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(
                16'h0000, 16'h0000, 16'h0000, 16'h0000,
                16'h0000, 16'h0000, 16'h0004, 16'h0000
            );
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Sequence 1,2,3,4", test_num);
            x0 = 16'h0001;
            x1 = 16'h0002;
            x2 = 16'h0003;
            x3 = 16'h0004;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(
                16'h0000, 16'h0002, 16'h0000, 16'hFFFE,
                16'h000A, 16'hFFFE, 16'hFFFE, 16'hFFFE
            );
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Large Signed Values", test_num);
            x0 = 16'h000A;
            x1 = 16'h000A;
            x2 = 16'hFFF6;
            x3 = 16'hFFF6;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(
                16'h0000, 16'hFFEC, 16'h0000, 16'h0014,
                16'h0000, 16'h0014, 16'h0000, 16'h0014
            );
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: All Zeros", test_num);
            x0 = 16'h0000;
            x1 = 16'h0000;
            x2 = 16'h0000;
            x3 = 16'h0000;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(
                16'h0000, 16'h0000, 16'h0000, 16'h0000,
                16'h0000, 16'h0000, 16'h0000, 16'h0000
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
        testcase006();
        
        
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
        input [15:0] expected_im0;
        input [15:0] expected_im1;
        input [15:0] expected_im2;
        input [15:0] expected_im3;
        input [15:0] expected_re0;
        input [15:0] expected_re1;
        input [15:0] expected_re2;
        input [15:0] expected_re3;
        begin
            if (expected_im0 === (expected_im0 ^ im0 ^ expected_im0) &&
                expected_im1 === (expected_im1 ^ im1 ^ expected_im1) &&
                expected_im2 === (expected_im2 ^ im2 ^ expected_im2) &&
                expected_im3 === (expected_im3 ^ im3 ^ expected_im3) &&
                expected_re0 === (expected_re0 ^ re0 ^ expected_re0) &&
                expected_re1 === (expected_re1 ^ re1 ^ expected_re1) &&
                expected_re2 === (expected_re2 ^ re2 ^ expected_re2) &&
                expected_re3 === (expected_re3 ^ re3 ^ expected_re3)) begin
                $display("PASS");
                $display("  Outputs: im0=%h, im1=%h, im2=%h, im3=%h, re0=%h, re1=%h, re2=%h, re3=%h",
                         im0, im1, im2, im3, re0, re1, re2, re3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: im0=%h, im1=%h, im2=%h, im3=%h, re0=%h, re1=%h, re2=%h, re3=%h",
                         expected_im0, expected_im1, expected_im2, expected_im3, expected_re0, expected_re1, expected_re2, expected_re3);
                $display("  Got:      im0=%h, im1=%h, im2=%h, im3=%h, re0=%h, re1=%h, re2=%h, re3=%h",
                         im0, im1, im2, im3, re0, re1, re2, re3);
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
        $dumpvars(0,clk, rst, x0, x1, x2, x3, im0, im1, im2, im3, re0, re1, re2, re3);
    end

endmodule
