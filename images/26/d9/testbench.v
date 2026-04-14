`timescale 1ns/1ps

module fft_4point_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] x0;
    reg [15:0] x1;
    reg [15:0] x2;
    reg [15:0] x3;
    wire [15:0] y0;
    wire [15:0] y1;
    wire [15:0] y2;
    wire [15:0] y3;

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
            rst = 1;
            x0 = 16'h0;
            x1 = 16'h0;
            x2 = 16'h0;
            x3 = 16'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("\nTestcase %0d: Impulse at x0", test_num);
            x0 = 16'h0100;
            x1 = 16'h0000;
            x2 = 16'h0000;
            x3 = 16'h0000;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'h0100, 16'h0100, 16'h0100, 16'h0100);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("\nTestcase %0d: DC Component", test_num);
            x0 = 16'h0100;
            x1 = 16'h0100;
            x2 = 16'h0100;
            x3 = 16'h0100;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'h0400, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("\nTestcase %0d: Real Sine wave", test_num);
            x0 = 16'h0100;
            x1 = 16'h0000;
            x2 = 16'hFF00;
            x3 = 16'h0000;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'h0000, 16'h0200, 16'h0000, 16'h0200);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("\nTestcase %0d: Impulse at x1", test_num);
            x0 = 16'h0000;
            x1 = 16'h0100;
            x2 = 16'h0000;
            x3 = 16'h0000;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(16'h0100, 16'h00FF, 16'hFF00, 16'h0001);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("\nTestcase %0d: Complex DC Offset", test_num);
            x0 = 16'h0101;
            x1 = 16'h0101;
            x2 = 16'h0101;
            x3 = 16'h0101;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'h0404, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("\nTestcase %0d: Alternating Complex Signal", test_num);
            x0 = 16'h0101;
            x1 = 16'hFFEF;
            x1 = 16'hFFFF;
            x2 = 16'h0101;
            x3 = 16'hFFFF;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(16'h0000, 16'h0000, 16'h0404, 16'h0000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("\nTestcase %0d: All Zeros", test_num);
            x0 = 16'h0; x1 = 16'h0; x2 = 16'h0; x3 = 16'h0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'h0, 16'h0, 16'h0, 16'h0);
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
        testcase007();
        
        
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
        input [15:0] expected_y0;
        input [15:0] expected_y1;
        input [15:0] expected_y2;
        input [15:0] expected_y3;
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
        $dumpvars(0,clk, rst, x0, x1, x2, x3, y0, y1, y2, y3);
    end

endmodule
