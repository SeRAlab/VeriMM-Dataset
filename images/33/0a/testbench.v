`timescale 1ns/1ps

module IIR_Filter_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a1;
    reg [15:0] a2;
    reg [15:0] b0;
    reg [15:0] b1;
    reg [15:0] b2;
    reg clk;
    reg rst;
    reg [15:0] x;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    IIR_Filter dut (
        .a1(a1),
        .a2(a2),
        .b0(b0),
        .b1(b1),
        .b2(b2),
        .clk(clk),
        .rst(rst),
        .x(x),
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
            x = 0;
            a1 = 0; a2 = 0;
            b0 = 0; b1 = 0; b2 = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Impulse response (B coefficients)", test_num);
            reset_dut();

            b0 = 16'd1; b1 = 16'd2; b2 = 16'd3;
            a1 = 16'd0; a2 = 16'd0;

            x = 16'd5;
            @(posedge clk); #1;
            x = 16'd0;
            @(posedge clk); #1;
            x = 16'd0;
            @(posedge clk); #1;

            #1;


            check_outputs(16'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Recursive Feedback (A coefficients)", test_num);
            reset_dut();

            b0 = 16'd1; b1 = 16'd0; b2 = 16'd0;
            a1 = 16'd2; a2 = 16'd0;

            x = 16'd10;
            @(posedge clk); #1;
            x = 16'd0;
            @(posedge clk); #1;
            x = 16'd0;
            @(posedge clk); #1;

            #1;


            check_outputs(16'd40);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Full Equation Mixed coefficients", test_num);
            reset_dut();

            b0 = 16'd2; b1 = 16'd1; b2 = 16'd0;
            a1 = 16'd1; a2 = 16'd0;

            x = 16'd10;
            @(posedge clk); #1;
            x = 16'd5;
            @(posedge clk); #1;
            x = 16'd0;
            @(posedge clk); #1;

            #1;


            check_outputs(16'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Input Response", test_num);
            reset_dut();

            b0 = 16'hFFFF; b1 = 16'hA5A5; b2 = 16'h1234;
            a1 = 16'h0001; a2 = 16'h0002;
            x = 16'd0;

            repeat(5) @(posedge clk); #1;

            #1;


            check_outputs(16'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Second Order Delays (b2/a2)", test_num);
            reset_dut();

            b0 = 16'd0; b1 = 16'd0; b2 = 16'd4;
            a1 = 16'd0; a2 = 16'hFFFF;

            x = 16'd2;
            @(posedge clk); #1;
            x = 16'd0;
            @(posedge clk); #1;
            x = 16'd0;
            @(posedge clk); #1;
            x = 16'd0;
            @(posedge clk); #1;
            x = 16'd0;
            @(posedge clk); #1;

            #1;


            check_outputs(16'd8);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("IIR_Filter Testbench");
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
        input [15:0] expected_y;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
        $dumpvars(0,a1, a2, b0, b1, b2, clk, rst, x, y);
    end

endmodule
