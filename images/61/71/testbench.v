`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data;
    reg enable;
    reg initialize;
    wire [14:0] crc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .enable(enable),
        .initialize(initialize),
        .crc(crc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            initialize = 1;
            enable = 0;
            data = 0;
            @(posedge clk);
            #1;
            initialize = 0;
            data = 0;
            enable = 0;
        end
        endtask
    task send_bit;

        input b;
        begin
            data = b;
            enable = 1;
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initializing CRC...", test_num);
            reset_dut();
            #1;

            check_outputs(15'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single bit '1'...", test_num);
            reset_dut();
            send_bit(1);
            #1;

            check_outputs(15'h4599);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data sequence '10'...", test_num);
            reset_dut();
            send_bit(1);
            send_bit(0);
            #1;

            check_outputs(15'h4EAB);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data sequence '111'...", test_num);
            reset_dut();
            send_bit(1);
            send_bit(1);
            send_bit(1);
            #1;

            check_outputs(15'h53FD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data sequence 8'hA5 (10100101)...", test_num);
            reset_dut();
            send_bit(1); send_bit(0); send_bit(1); send_bit(0);
            send_bit(0); send_bit(1); send_bit(0); send_bit(1);
            #1;

            check_outputs(15'h6F59);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Enable signal gating...", test_num);
            reset_dut();
            data = 1;
            enable = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(15'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Interrupted sequence...", test_num);
            reset_dut();
            send_bit(1);
            enable = 0;
            data = 1;
            @(posedge clk); #1;
            send_bit(0);
            #1;

            check_outputs(15'h4EAB);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sequence '11111'...", test_num);
            reset_dut();
            send_bit(1); send_bit(1); send_bit(1); send_bit(1); send_bit(1);
            #1;

            check_outputs(15'h0A6D);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Runtime Initialization...", test_num);
            reset_dut();
            send_bit(1);
            send_bit(1);
            initialize = 1;
            @(posedge clk); #1;
            initialize = 0;
            #1;

            check_outputs(15'h0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Zero bit sequence...", test_num);
            reset_dut();
            send_bit(0); send_bit(0); send_bit(0);
            #1;

            check_outputs(15'h0000);
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
        input [14:0] expected_crc;
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
        $dumpvars(0,clk, data, enable, initialize, crc);
    end

endmodule
