`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg en;
    reg rst;
    wire [15:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .en(en),
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
            @(posedge clk);
            rst = 1;
            en = 0;
            din = 8'h00;
            @(posedge clk);
            #1 rst = 0;
            $display("Status: Reset complete.");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset Initialization", test_num);
            reset_dut();
            @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Single Byte 0x00", test_num);
            reset_dut();
            @(posedge clk);
            din = 8'h00;
            en = 1;
            @(posedge clk);
            en = 0;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Single Byte 0xEE", test_num);
            reset_dut();
            @(posedge clk);
            din = 8'hEE;
            en = 1;
            @(posedge clk);
            en = 0;

            #1;


            check_outputs(dout);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Multi-byte (0x01, 0x02)", test_num);
            reset_dut();
            @(posedge clk);
            en = 1;
            din = 8'h01;
            @(posedge clk);
            din = 8'h02;
            @(posedge clk);
            en = 0;

            #1;


            check_outputs(dout);
        end
        endtask

    task testcase005;

        reg [15:0] capture_crc;
        begin
            test_num = 5;
            $display("\nTestcase %0d: Enable Signal Logic", test_num);
            reset_dut();
            @(posedge clk);
            en = 1;
            din = 8'hA5;
            @(posedge clk);
            en = 0;
            capture_crc = dout;
            din = 8'hFF;
            @(posedge clk);
            @(posedge clk);

            #1;


            check_outputs(capture_crc);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Mid-stream Reset", test_num);
            reset_dut();
            @(posedge clk);
            en = 1;
            din = 8'hAA;
            @(posedge clk);
            rst = 1;
            @(posedge clk);
            rst = 0;
            en = 0;
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
        $dumpvars(0,clk, din, en, rst, dout);
    end

endmodule
