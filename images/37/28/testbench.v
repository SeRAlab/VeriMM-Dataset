`timescale 1ns/1ps

module fft_4_point_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg start;
    reg [7:0] x_im0;
    reg [7:0] x_im1;
    reg [7:0] x_im2;
    reg [7:0] x_im3;
    reg [7:0] x_re0;
    reg [7:0] x_re1;
    reg [7:0] x_re2;
    reg [7:0] x_re3;
    wire [7:0] y_im0;
    wire [7:0] y_im1;
    wire [7:0] y_im2;
    wire [7:0] y_im3;
    wire [7:0] y_re0;
    wire [7:0] y_re1;
    wire [7:0] y_re2;
    wire [7:0] y_re3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_4_point dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .x_im0(x_im0),
        .x_im1(x_im1),
        .x_im2(x_im2),
        .x_im3(x_im3),
        .x_re0(x_re0),
        .x_re1(x_re1),
        .x_re2(x_re2),
        .x_re3(x_re3),
        .y_im0(y_im0),
        .y_im1(y_im1),
        .y_im2(y_im2),
        .y_im3(y_im3),
        .y_re0(y_re0),
        .y_re1(y_re1),
        .y_re2(y_re2),
        .y_re3(y_re3)
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
            x_re0 = 0; x_im0 = 0;
            x_re1 = 0; x_im1 = 0;
            x_re2 = 0; x_im2 = 0;
            x_re3 = 0; x_im3 = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Impulse Input x[0]=16", test_num);
            @(posedge clk);
            start = 1;
            x_re0 = 8'h10; x_im0 = 8'h00;
            x_re1 = 8'h00; x_im1 = 8'h00;
            x_re2 = 8'h00; x_im2 = 8'h00;
            x_re3 = 8'h00; x_im3 = 8'h00;
            @(posedge clk);
            start = 0;

            repeat(4) @(posedge clk);
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h10, 8'h10, 8'h10, 8'h10);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: DC Signal (Real=10)", test_num);
            @(posedge clk);
            start = 1;
            x_re0 = 8'h0A; x_re1 = 8'h0A; x_re2 = 8'h0A; x_re3 = 8'h0A;
            x_im0 = 8'h00; x_im1 = 8'h00; x_im2 = 8'h00; x_im3 = 8'h00;
            @(posedge clk);
            start = 0;
            repeat(4) @(posedge clk);
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h28, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Real Sine wave (10, 0, -10, 0)", test_num);
            @(posedge clk);
            start = 1;
            x_re0 = 8'h0A; x_re1 = 8'h00; x_re2 = 8'hF6; x_re3 = 8'h00;
            x_im0 = 8'h00; x_im1 = 8'h00; x_im2 = 8'h00; x_im3 = 8'h00;
            @(posedge clk);
            start = 0;
            repeat(4) @(posedge clk);
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h14, 8'h00, 8'h14);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Complex Rotation", test_num);
            @(posedge clk);
            start = 1;
            x_re0 = 8'h0A; x_im0 = 8'h00;
            x_re1 = 8'h00; x_im1 = 8'h0A;
            x_re2 = 8'hF6; x_im2 = 8'h00;
            x_re3 = 8'h00; x_im3 = 8'hF6;
            @(posedge clk);
            start = 0;
            repeat(4) @(posedge clk);
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h28, 8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Negative DC Signal (-5)", test_num);
            @(posedge clk);
            start = 1;
            x_re0 = 8'hFB; x_re1 = 8'hFB; x_re2 = 8'hFB; x_re3 = 8'hFB;
            x_im0 = 8'h00; x_im1 = 8'h00; x_im2 = 8'h00; x_im3 = 8'h00;
            @(posedge clk);
            start = 0;
            repeat(4) @(posedge clk);
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'hEC, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            @(posedge clk);
            start = 1;
            x_re0 = 8'h00; x_re1 = 8'h00; x_re2 = 8'h00; x_re3 = 8'h00;
            x_im0 = 8'h00; x_im1 = 8'h00; x_im2 = 8'h00; x_im3 = 8'h00;
            @(posedge clk);
            start = 0;
            repeat(4) @(posedge clk);
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fft_4_point Testbench");
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
        input [7:0] expected_y_im0;
        input [7:0] expected_y_im1;
        input [7:0] expected_y_im2;
        input [7:0] expected_y_im3;
        input [7:0] expected_y_re0;
        input [7:0] expected_y_re1;
        input [7:0] expected_y_re2;
        input [7:0] expected_y_re3;
        begin
            if (expected_y_im0 === (expected_y_im0 ^ y_im0 ^ expected_y_im0) &&
                expected_y_im1 === (expected_y_im1 ^ y_im1 ^ expected_y_im1) &&
                expected_y_im2 === (expected_y_im2 ^ y_im2 ^ expected_y_im2) &&
                expected_y_im3 === (expected_y_im3 ^ y_im3 ^ expected_y_im3) &&
                expected_y_re0 === (expected_y_re0 ^ y_re0 ^ expected_y_re0) &&
                expected_y_re1 === (expected_y_re1 ^ y_re1 ^ expected_y_re1) &&
                expected_y_re2 === (expected_y_re2 ^ y_re2 ^ expected_y_re2) &&
                expected_y_re3 === (expected_y_re3 ^ y_re3 ^ expected_y_re3)) begin
                $display("PASS");
                $display("  Outputs: y_im0=%h, y_im1=%h, y_im2=%h, y_im3=%h, y_re0=%h, y_re1=%h, y_re2=%h, y_re3=%h",
                         y_im0, y_im1, y_im2, y_im3, y_re0, y_re1, y_re2, y_re3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y_im0=%h, y_im1=%h, y_im2=%h, y_im3=%h, y_re0=%h, y_re1=%h, y_re2=%h, y_re3=%h",
                         expected_y_im0, expected_y_im1, expected_y_im2, expected_y_im3, expected_y_re0, expected_y_re1, expected_y_re2, expected_y_re3);
                $display("  Got:      y_im0=%h, y_im1=%h, y_im2=%h, y_im3=%h, y_re0=%h, y_re1=%h, y_re2=%h, y_re3=%h",
                         y_im0, y_im1, y_im2, y_im3, y_re0, y_re1, y_re2, y_re3);
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
        $dumpvars(0,clk, rst, start, x_im0, x_im1, x_im2, x_im3, x_re0, x_re1, x_re2, x_re3, y_im0, y_im1, y_im2, y_im3, y_re0, y_re1, y_re2, y_re3);
    end

endmodule
