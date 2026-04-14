`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] iaddrbusWire1;
    reg reset;
    wire [63:0] iaddrbusOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .iaddrbusWire1(iaddrbusWire1),
        .reset(reset),
        .iaddrbusOut(iaddrbusOut)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            iaddrbusWire1 = 64'h0;
            @(posedge clk);
            #2;
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();


            reset = 1;
            iaddrbusWire1 = 64'hFFFF_FFFF_FFFF_FFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h0);
            reset = 0;
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            iaddrbusWire1 = 64'h0000_0000_0000_0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h0000_0000_0000_0004);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            iaddrbusWire1 = 64'h1234_5678_9ABC_DEF0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h1234_5678_9ABC_DEF4);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            iaddrbusWire1 = 64'hFFFF_FFFF_FFFF_FFFC;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h0000_0000_0000_0000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            iaddrbusWire1 = 64'h0000_0000_0000_0010;
            @(posedge clk);
            #2;

            iaddrbusWire1 = 64'h0000_0000_0000_0020;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h0000_0000_0000_0024);
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
        input [63:0] expected_iaddrbusOut;
        begin
            if (expected_iaddrbusOut === (expected_iaddrbusOut ^ iaddrbusOut ^ expected_iaddrbusOut)) begin
                $display("PASS");
                $display("  Outputs: iaddrbusOut=%h",
                         iaddrbusOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: iaddrbusOut=%h",
                         expected_iaddrbusOut);
                $display("  Got:      iaddrbusOut=%h",
                         iaddrbusOut);
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
        $dumpvars(0,clk, iaddrbusWire1, reset, iaddrbusOut);
    end

endmodule
