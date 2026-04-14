`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg FIFO_EMPTY;
    reg INT_RDY;
    reg clk;
    wire FIFO_RD_EN;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .FIFO_EMPTY(FIFO_EMPTY),
        .INT_RDY(INT_RDY),
        .clk(clk),
        .FIFO_RD_EN(FIFO_RD_EN)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            FIFO_EMPTY = 1'b1;
            INT_RDY = 1'b0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            FIFO_EMPTY = 1'b1;
            INT_RDY = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            FIFO_EMPTY = 1'b1;
            INT_RDY = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            FIFO_EMPTY = 1'b0;
            INT_RDY = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            FIFO_EMPTY = 1'b0;
            INT_RDY = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            FIFO_EMPTY = 1'b0;
            INT_RDY = 1'b1;
            @(posedge clk);
            #2;

            FIFO_EMPTY = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
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
        input expected_FIFO_RD_EN;
        begin
            if (expected_FIFO_RD_EN === (expected_FIFO_RD_EN ^ FIFO_RD_EN ^ expected_FIFO_RD_EN)) begin
                $display("PASS");
                $display("  Outputs: FIFO_RD_EN=%b",
                         FIFO_RD_EN);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: FIFO_RD_EN=%b",
                         expected_FIFO_RD_EN);
                $display("  Got:      FIFO_RD_EN=%b",
                         FIFO_RD_EN);
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
        $dumpvars(0,FIFO_EMPTY, INT_RDY, clk, FIFO_RD_EN);
    end

endmodule
