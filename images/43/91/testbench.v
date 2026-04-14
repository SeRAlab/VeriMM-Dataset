`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg bitIn;
    reg spiClock;
    reg start;
    reg waitForBitIn;
    wire [7:0] byteOut;
    wire finish;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bitIn(bitIn),
        .spiClock(spiClock),
        .start(start),
        .waitForBitIn(waitForBitIn),
        .byteOut(byteOut),
        .finish(finish)
    );

    // Clock generation (10ns period)
    initial begin
        spiClock = 0;
        forever #5 spiClock = ~spiClock;
    end

        task reset_dut;

        begin
            start = 0;
            bitIn = 0;
            waitForBitIn = 0;
            repeat (2) @(posedge spiClock);
        end
        endtask
    task shift_byte;

        input [7:0] data;
        integer i;
        begin
            for (i = 7; i >= 0; i = i - 1) begin
                bitIn = data[i];
                @(posedge spiClock);
            end
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(negedge spiClock);
            start = 1;
            waitForBitIn = 0;

            shift_byte(8'hA5);

            start = 0;

            #1;


            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(negedge spiClock);
            start = 1;
            waitForBitIn = 1;
            bitIn = 0;


            repeat (3) @(posedge spiClock);


            bitIn = 1;
            @(posedge spiClock);


            shift_byte(8'h5A);

            start = 0;
            #1;

            check_outputs(8'h5A, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(negedge spiClock);
            start = 1;
            waitForBitIn = 0;

            shift_byte(8'hFF);

            start = 0;
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(negedge spiClock);
            start = 1;
            waitForBitIn = 0;

            shift_byte(8'h00);

            start = 0;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(negedge spiClock);
            start = 1;
            waitForBitIn = 0;


            shift_byte(8'h12);




            shift_byte(8'h34);

            start = 0;
            #1;

            check_outputs(8'h34, 1'b1);
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
        input [7:0] expected_byteOut;
        input expected_finish;
        begin
            if (expected_byteOut === (expected_byteOut ^ byteOut ^ expected_byteOut) &&
                expected_finish === (expected_finish ^ finish ^ expected_finish)) begin
                $display("PASS");
                $display("  Outputs: byteOut=%h, finish=%b",
                         byteOut, finish);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: byteOut=%h, finish=%b",
                         expected_byteOut, expected_finish);
                $display("  Got:      byteOut=%h, finish=%b",
                         byteOut, finish);
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
        $dumpvars(0,bitIn, spiClock, start, waitForBitIn, byteOut, finish);
    end

endmodule
