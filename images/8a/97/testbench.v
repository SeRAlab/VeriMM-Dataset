`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clrFifo;
    reg trigWrite;
    wire sclr;
    wire writeReq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clrFifo(clrFifo),
        .trigWrite(trigWrite),
        .sclr(sclr),
        .writeReq(writeReq)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            trigWrite = 0;
            clrFifo = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Idle State Check", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: FIFO Clear Assertion", test_num);
            reset_dut();
            clrFifo = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Write Request Pulse Check", test_num);
            reset_dut();
            trigWrite = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Single Cycle Pulse Duration Check", test_num);
            reset_dut();
            trigWrite = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Simultaneous Clear and Trigger", test_num);
            reset_dut();
            clrFifo = 1;
            trigWrite = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Successive Trigger Check", test_num);
            reset_dut();

            trigWrite = 1;
            repeat(3) @(posedge clk);
            trigWrite = 0;
            @(posedge clk);

            trigWrite = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1);
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
        input expected_sclr;
        input expected_writeReq;
        begin
            if (expected_sclr === (expected_sclr ^ sclr ^ expected_sclr) &&
                expected_writeReq === (expected_writeReq ^ writeReq ^ expected_writeReq)) begin
                $display("PASS");
                $display("  Outputs: sclr=%b, writeReq=%b",
                         sclr, writeReq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sclr=%b, writeReq=%b",
                         expected_sclr, expected_writeReq);
                $display("  Got:      sclr=%b, writeReq=%b",
                         sclr, writeReq);
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
        $dumpvars(0,clk, clrFifo, trigWrite, sclr, writeReq);
    end

endmodule
