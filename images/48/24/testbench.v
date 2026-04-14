`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg DMWr;
    reg clk;
    reg [31:0] din;
    reg [6:0] index;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DMWr(DMWr),
        .clk(clk),
        .din(din),
        .index(index),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            DMWr = 0;
            index = 0;
            din = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase 001: Basic Write and Read");

            index = 7'h0A;
            din = 32'hA5A5A5A5;
            DMWr = 1;
            @(posedge clk);
            #2;

            DMWr = 0;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase 002: Write Enable Low Check");


            index = 7'h15;
            din = 32'h11111111;
            DMWr = 1;
            @(posedge clk);
            #2;


            din = 32'hEEEEEEEE;
            DMWr = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(32'h11111111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase 003: Multiple Memory Locations");


            index = 7'd50;
            din = 32'h12345678;
            DMWr = 1;
            @(posedge clk);
            #1;


            index = 7'd51;
            din = 32'h87654321;
            DMWr = 1;
            @(posedge clk);
            #1;


            DMWr = 0;
            index = 7'd50;
            #2;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase 004: Boundary Address 127");

            index = 7'd127;
            din = 32'hFFFFFFFF;
            DMWr = 1;
            @(posedge clk);
            #2;

            DMWr = 0;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase 005: Overwrite Data at same index");

            index = 7'd64;
            din = 32'h00000001;
            DMWr = 1;
            @(posedge clk);
            #2;

            din = 32'h80000000;
            @(posedge clk);
            #2;

            DMWr = 0;
            #1;

            check_outputs(32'h80000000);
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
        input [31:0] expected_dout;
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
        $dumpvars(0,DMWr, clk, din, index, dout);
    end

endmodule
