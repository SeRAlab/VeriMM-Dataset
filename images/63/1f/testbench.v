`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg bitval;
    reg clk;
    reg en;
    reg rst;
    wire [15:0] crc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bitval(bitval),
        .clk(clk),
        .en(en),
        .rst(rst),
        .crc(crc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            #1;
            rst = 1;
            en = 0;
            bitval = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task send_bit;

        input b;
        begin
            @(posedge clk);
            #1;
            en = 1;
            bitval = b;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single bit '1'", test_num);
            reset_dut();
            send_bit(1);
            @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(16'h1021);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequence 1011", test_num);
            reset_dut();
            send_bit(1);
            send_bit(0);
            send_bit(1);
            send_bit(1);
            @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(16'hB16B);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Byte 0x80 (10000000)", test_num);
            reset_dut();
            send_bit(1);
            send_bit(0);
            send_bit(0);
            send_bit(0);
            send_bit(0);
            send_bit(0);
            send_bit(0);
            send_bit(0);
            @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(16'h9188);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Signal Toggle", test_num);
            reset_dut();
            send_bit(1);


            @(posedge clk);
            #1;
            en = 0;
            bitval = 1;
            repeat(2) @(posedge clk);

            send_bit(0);
            @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(16'h2042);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during operation", test_num);
            reset_dut();
            send_bit(1);
            send_bit(1);
            reset_dut();
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
        input [15:0] expected_crc;
        begin
            if (expected_crc === (expected_crc ^ crc ^ expected_crc)) begin
                $display("PASS");
                $display("  Outputs: crc=%h",
                         crc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc=%h",
                         expected_crc);
                $display("  Got:      crc=%h",
                         crc);
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
        $dumpvars(0,bitval, clk, en, rst, crc);
    end

endmodule
