`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [11:0] din;
    reg dstrb;
    reg ena;
    reg rst;
    wire [11:0] dout;
    wire douten;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .dstrb(dstrb),
        .ena(ena),
        .rst(rst),
        .dout(dout),
        .douten(douten)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ena = 0;
            dstrb = 0;
            din = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            ena = 1;
            dstrb = 1;
            din = 12'sd100;
            @(posedge clk);
            #1;

            check_outputs(12'sd100, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            ena = 1;
            dstrb = 1;
            din = 12'sd100;
            @(posedge clk);
            din = 12'sd250;
            @(posedge clk);
            #1;

            check_outputs(12'sd150, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            ena = 1;
            dstrb = 1;
            din = 12'sd200;
            @(posedge clk);
            din = 12'sd50;
            @(posedge clk);
            #1;

            check_outputs(-12'sd150, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            ena = 1; dstrb = 1; din = 12'sd100;
            @(posedge clk);

            ena = 0; dstrb = 1; din = 12'sd500;
            @(posedge clk);

            ena = 1; dstrb = 1; din = 12'sd150;
            @(posedge clk);

            #1;


            check_outputs(12'sd50, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            ena = 1; dstrb = 1; din = 12'sd100;
            @(posedge clk);

            ena = 1; dstrb = 0; din = 12'sd999;
            @(posedge clk);

            #1;


            check_outputs(dout, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            ena = 1; dstrb = 1;
            din = 12'h800;
            @(posedge clk);
            din = 12'h7FF;
            @(posedge clk);
            #1;

            check_outputs(12'sd2047 - (-12'sd2048), 1'b1);
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
        input [11:0] expected_dout;
        input expected_douten;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_douten === (expected_douten ^ douten ^ expected_douten)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, douten=%b",
                         dout, douten);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, douten=%b",
                         expected_dout, expected_douten);
                $display("  Got:      dout=%h, douten=%b",
                         dout, douten);
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
        $dumpvars(0,clk, din, dstrb, ena, rst, dout, douten);
    end

endmodule
