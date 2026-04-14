`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg aclk;
    reg areset;
    wire [3:0] count;
    wire overflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aclk(aclk),
        .areset(areset),
        .count(count),
        .overflow(overflow)
    );

    // Clock generation (10ns period)
    initial begin
        aclk = 0;
        forever #5 aclk = ~aclk;
    end

        task reset_dut;

        begin
            areset = 1;
            @(posedge aclk);
            #1;
            areset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge aclk);
            #1;

            #1;


            check_outputs(4'd1, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            reset_dut();
            for (i = 0; i < 15; i = i + 1) begin
                @(posedge aclk);
            end
            #1;

            #1;


            check_outputs(4'd15, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            reset_dut();

            for (i = 0; i < 16; i = i + 1) begin
                @(posedge aclk);
            end
            #1;

            #1;


            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            reset_dut();

            for (i = 0; i < 17; i = i + 1) begin
                @(posedge aclk);
            end
            #1;

            #1;


            check_outputs(4'd1, 1'b0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            reset_dut();
            for (i = 0; i < 5; i = i + 1) begin
                @(posedge aclk);
            end
            #1;
            areset = 1;
            @(posedge aclk);
            #1;
            areset = 0;

            #1;


            check_outputs(4'd0, 1'b0);
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
        input [3:0] expected_count;
        input expected_overflow;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow)) begin
                $display("PASS");
                $display("  Outputs: count=%h, overflow=%b",
                         count, overflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, overflow=%b",
                         expected_count, expected_overflow);
                $display("  Got:      count=%h, overflow=%b",
                         count, overflow);
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
        $dumpvars(0,aclk, areset, count, overflow);
    end

endmodule
