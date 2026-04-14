`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg pb_debounced;
    reg rst;
    wire pb_1pulse;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pb_debounced(pb_debounced),
        .rst(rst),
        .pb_1pulse(pb_1pulse)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            pb_debounced = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            pb_debounced = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            pb_debounced = 1;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            pb_debounced = 1;
            repeat(5) @(posedge clk);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            pb_debounced = 1;
            repeat(2) @(posedge clk);

            pb_debounced = 0;
            @(posedge clk);

            pb_debounced = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            pb_debounced = 1;
            @(posedge clk);
            rst = 1;
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            pb_debounced = 0;
            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(0);
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
        input expected_pb_1pulse;
        begin
            if (expected_pb_1pulse === (expected_pb_1pulse ^ pb_1pulse ^ expected_pb_1pulse)) begin
                $display("PASS");
                $display("  Outputs: pb_1pulse=%b",
                         pb_1pulse);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pb_1pulse=%b",
                         expected_pb_1pulse);
                $display("  Got:      pb_1pulse=%b",
                         pb_1pulse);
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
        $dumpvars(0,clk, pb_debounced, rst, pb_1pulse);
    end

endmodule
