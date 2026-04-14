`timescale 1ns/1ps

module FFT_4point_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] im_in0;
    reg [15:0] im_in1;
    reg [15:0] im_in2;
    reg [15:0] im_in3;
    reg [15:0] re_in0;
    reg [15:0] re_in1;
    reg [15:0] re_in2;
    reg [15:0] re_in3;
    reg reset;
    wire [15:0] im_out0;
    wire [15:0] im_out1;
    wire [15:0] im_out2;
    wire [15:0] im_out3;
    wire [15:0] re_out0;
    wire [15:0] re_out1;
    wire [15:0] re_out2;
    wire [15:0] re_out3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    FFT_4point dut (
        .clk(clk),
        .im_in0(im_in0),
        .im_in1(im_in1),
        .im_in2(im_in2),
        .im_in3(im_in3),
        .re_in0(re_in0),
        .re_in1(re_in1),
        .re_in2(re_in2),
        .re_in3(re_in3),
        .reset(reset),
        .im_out0(im_out0),
        .im_out1(im_out1),
        .im_out2(im_out2),
        .im_out3(im_out3),
        .re_out0(re_out0),
        .re_out1(re_out1),
        .re_out2(re_out2),
        .re_out3(re_out3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            re_in0 = 0; im_in0 = 0;
            re_in1 = 0; im_in1 = 0;
            re_in2 = 0; im_in2 = 0;
            re_in3 = 0; im_in3 = 0;
            repeat(2) @(posedge clk);
            #1;
            reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All Zeros", test_num);
            reset_dut();

            re_in0 = 16'h0000; im_in0 = 16'h0000;
            re_in1 = 16'h0000; im_in1 = 16'h0000;
            re_in2 = 16'h0000; im_in2 = 16'h0000;
            re_in3 = 16'h0000; im_in3 = 16'h0000;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0, 16'h0, 16'h0, 16'h0, 16'h0, 16'h0, 16'h0, 16'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: DC Signal", test_num);
            reset_dut();

            re_in0 = 16'h0001; im_in0 = 16'h0000;
            re_in1 = 16'h0001; im_in1 = 16'h0000;
            re_in2 = 16'h0001; im_in2 = 16'h0000;
            re_in3 = 16'h0001; im_in3 = 16'h0000;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0, 16'h0, 16'h0, 16'h0, 16'h4, 16'h0, 16'h0, 16'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Unit Impulse", test_num);
            reset_dut();

            re_in0 = 16'h0005; im_in0 = 16'h0000;
            re_in1 = 16'h0000; im_in1 = 16'h0000;
            re_in2 = 16'h0000; im_in2 = 16'h0000;
            re_in3 = 16'h0000; im_in3 = 16'h0000;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0, 16'h0, 16'h0, 16'h0, 16'h5, 16'h5, 16'h5, 16'h5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Nyquist Frequency", test_num);
            reset_dut();

            re_in0 = 16'h0001; im_in0 = 16'h0000;
            re_in1 = 16'hFFFF; im_in1 = 16'h0000;
            re_in2 = 16'h0001; im_in2 = 16'h0000;
            re_in3 = 16'hFFFF; im_in3 = 16'h0000;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0, 16'h0, 16'h0, 16'h0, 16'h0, 16'h0, 16'h4, 16'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Complex Sinusoid", test_num);
            reset_dut();

            re_in0 = 16'h0001; im_in0 = 16'h0000;
            re_in1 = 16'h0000; im_in1 = 16'h0001;
            re_in2 = 16'hFFFF; im_in2 = 16'h0000;
            re_in3 = 16'h0000; im_in3 = 16'hFFFF;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0, 16'h0, 16'h0, 16'h0, 16'h0, 16'h4, 16'h0, 16'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Mixed Complex Values", test_num);
            reset_dut();

            re_in0 = 16'h0002; im_in0 = 16'h0003;
            re_in1 = 16'h0001; im_in1 = 16'hFFFF;
            re_in2 = 16'hFFFC; im_in2 = 16'h0002;
            re_in3 = 16'h0000; im_in3 = 16'h0005;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0009, 16'h0000, 16'h0001, 16'h0002, 16'hFFFF, 16'h0000, 16'hFFFD, 16'h000C);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("FFT_4point Testbench");
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
        input [15:0] expected_im_out0;
        input [15:0] expected_im_out1;
        input [15:0] expected_im_out2;
        input [15:0] expected_im_out3;
        input [15:0] expected_re_out0;
        input [15:0] expected_re_out1;
        input [15:0] expected_re_out2;
        input [15:0] expected_re_out3;
        begin
            if (expected_im_out0 === (expected_im_out0 ^ im_out0 ^ expected_im_out0) &&
                expected_im_out1 === (expected_im_out1 ^ im_out1 ^ expected_im_out1) &&
                expected_im_out2 === (expected_im_out2 ^ im_out2 ^ expected_im_out2) &&
                expected_im_out3 === (expected_im_out3 ^ im_out3 ^ expected_im_out3) &&
                expected_re_out0 === (expected_re_out0 ^ re_out0 ^ expected_re_out0) &&
                expected_re_out1 === (expected_re_out1 ^ re_out1 ^ expected_re_out1) &&
                expected_re_out2 === (expected_re_out2 ^ re_out2 ^ expected_re_out2) &&
                expected_re_out3 === (expected_re_out3 ^ re_out3 ^ expected_re_out3)) begin
                $display("PASS");
                $display("  Outputs: im_out0=%h, im_out1=%h, im_out2=%h, im_out3=%h, re_out0=%h, re_out1=%h, re_out2=%h, re_out3=%h",
                         im_out0, im_out1, im_out2, im_out3, re_out0, re_out1, re_out2, re_out3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: im_out0=%h, im_out1=%h, im_out2=%h, im_out3=%h, re_out0=%h, re_out1=%h, re_out2=%h, re_out3=%h",
                         expected_im_out0, expected_im_out1, expected_im_out2, expected_im_out3, expected_re_out0, expected_re_out1, expected_re_out2, expected_re_out3);
                $display("  Got:      im_out0=%h, im_out1=%h, im_out2=%h, im_out3=%h, re_out0=%h, re_out1=%h, re_out2=%h, re_out3=%h",
                         im_out0, im_out1, im_out2, im_out3, re_out0, re_out1, re_out2, re_out3);
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
        $dumpvars(0,clk, im_in0, im_in1, im_in2, im_in3, re_in0, re_in1, re_in2, re_in3, reset, im_out0, im_out1, im_out2, im_out3, re_out0, re_out1, re_out2, re_out3);
    end

endmodule
