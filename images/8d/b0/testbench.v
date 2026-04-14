`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg RESET;
    reg [3:0] SHIFT;
    reg clk;
    reg ctrl;
    reg [15:0] in0;
    reg [15:0] in1;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RESET(RESET),
        .SHIFT(SHIFT),
        .clk(clk),
        .ctrl(ctrl),
        .in0(in0),
        .in1(in1),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            RESET = 1;
            in0 = 0;
            in1 = 0;
            ctrl = 0;
            SHIFT = 0;
            @(posedge clk);
            RESET = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Addition (10 + 5), No Shift", test_num);
            reset_dut();
            in0 = 16'd10; in1 = 16'd5; ctrl = 1'b0; SHIFT = 4'sd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Subtraction (20 - 4), No Shift", test_num);
            reset_dut();
            in0 = 16'd20; in1 = 16'd4; ctrl = 1'b1; SHIFT = 4'sd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd16);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition + Left Shift (15 << 2)", test_num);
            reset_dut();
            in0 = 16'd10; in1 = 16'd5; ctrl = 1'b0; SHIFT = 4'sd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd60);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition + Right Shift (128 >> 2)", test_num);
            reset_dut();
            in0 = 16'd100; in1 = 16'd28; ctrl = 1'b0; SHIFT = -4'sd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd32);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction + Left Shift (8 << 3)", test_num);
            reset_dut();
            in0 = 16'd10; in1 = 16'd2; ctrl = 1'b1; SHIFT = 4'sd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd64);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction Wrap + Right Shift (0xFFFF >> 4)", test_num);
            reset_dut();
            in0 = 16'd1; in1 = 16'd2; ctrl = 1'b1; SHIFT = -4'sd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0FFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Left Shift (1 << 7)", test_num);
            reset_dut();
            in0 = 16'h0001; in1 = 16'h0000; ctrl = 1'b0; SHIFT = 4'sd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0080);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Right Shift (0x8000 >> 8)", test_num);
            reset_dut();
            in0 = 16'h8000; in1 = 16'h0000; ctrl = 1'b0; SHIFT = -4'sd8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0080);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous Reset Verification", test_num);
            reset_dut();
            in0 = 16'hAAAA; in1 = 16'h5555; ctrl = 1'b0; SHIFT = 4'sd0;
            @(posedge clk);
            #1;
            RESET = 1;
            @(posedge clk);
            #1;
            RESET = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition 16-bit Overflow", test_num);
            reset_dut();
            in0 = 16'hFFFF; in1 = 16'h0001; ctrl = 1'b0; SHIFT = 4'sd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,RESET, SHIFT, clk, ctrl, in0, in1, q);
    end

endmodule
