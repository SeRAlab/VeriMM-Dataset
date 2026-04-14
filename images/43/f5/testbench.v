`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ce;
    reg clk;
    reg [7:0] in0;
    reg [7:0] in1;
    reg [15:0] in2;
    reg rst;
    wire [15:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .clk(clk),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .rst(rst),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ce = 0;
            in0 = 0;
            in1 = 0;
            in2 = 0;
            repeat(2) @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task wait_cycles;

        input integer n;
        begin
            repeat(n) @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            ce = 1;
            in0 = 8'd10;
            in1 = 8'd5;
            in2 = 16'd100;
            wait_cycles(3);
            #1;

            check_outputs(16'h0096);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            ce = 1;
            in0 = -8'sd10;
            in1 = 8'sd5;
            in2 = 16'd100;
            wait_cycles(3);
            #1;

            check_outputs(16'h0032);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            ce = 1;
            in0 = -8'sd128;
            in1 = 8'sd127;
            in2 = 16'd0;
            wait_cycles(3);
            #1;

            check_outputs(16'hC080);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            ce = 1;
            in0 = -8'sd128;
            in1 = -8'sd2;
            in2 = 16'd60000;
            wait_cycles(3);
            #1;

            check_outputs(16'hEB60);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            ce = 1;
            in0 = 8'sd127;
            in1 = 8'sd127;
            in2 = 16'd30000;
            wait_cycles(3);
            #1;

            check_outputs(16'hB431);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            ce = 1;
            in0 = 8'd2;
            in1 = 8'd2;
            in2 = 16'd10;
            wait_cycles(3);


            ce = 0;
            in0 = 8'd10;
            in1 = 8'd10;
            in2 = 16'd100;
            wait_cycles(3);

            #1;


            check_outputs(16'h000E);
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
        input [15:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,ce, clk, in0, in1, in2, rst, dout);
    end

endmodule
