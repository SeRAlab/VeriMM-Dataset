`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] ctrl;
    reg [15:0] din;
    wire [15:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ctrl(ctrl),
        .din(din),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ctrl = 4'h0;
            din = 16'h0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            din = 16'hABCD;
            ctrl = 4'h0;
            @(posedge clk);
            #2;
            $display("Test %0d: Direct Pass (ctrl=0)", test_num);
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            din = 16'hFFFF;
            ctrl = 4'h1;
            @(posedge clk);
            #2;
            $display("Test %0d: Mask Lower Byte (ctrl=1)", test_num);
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            din = 16'h55AA;
            ctrl = 4'h2;
            @(posedge clk);
            #2;
            $display("Test %0d: Set Upper Byte to 1 (ctrl=2)", test_num);
            #1;

            check_outputs(16'h01AA);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            din = 16'h1234;
            ctrl = 4'h3;
            @(posedge clk);
            #2;
            $display("Test %0d: Bitwise XOR FFFF (ctrl=3)", test_num);
            #1;

            check_outputs(16'hEDCB);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            din = 16'hAAAA;
            ctrl = 4'h4;
            @(posedge clk);
            #2;
            $display("Test %0d: Default Zero (ctrl=4)", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            din = 16'h5555;
            ctrl = 4'hF;
            @(posedge clk);
            #2;
            $display("Test %0d: Default Zero (ctrl=15)", test_num);
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
        $dumpvars(0,clk, ctrl, din, dout);
    end

endmodule
