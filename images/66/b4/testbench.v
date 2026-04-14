`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg shift;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .shift(shift),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            shift = 0;
            data_in = 0;
            repeat(4) @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 1010 (Shift=0), verify LSB is 0", test_num);
            reset_dut();

            @(negedge clk); data_in = 1; shift = 0;
            @(negedge clk); data_in = 0; shift = 0;
            @(negedge clk); data_in = 1; shift = 0;
            @(negedge clk); data_in = 0; shift = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 1011, Rotate Right (Preserve MSB), check LSB", test_num);
            reset_dut();

            @(negedge clk); data_in = 1; shift = 0;
            @(negedge clk); data_in = 0; shift = 0;
            @(negedge clk); data_in = 1; shift = 0;
            @(negedge clk); data_in = 1; shift = 0;

            @(negedge clk); shift = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Propagate MSB=1 across register", test_num);
            reset_dut();

            @(negedge clk); data_in = 1; shift = 0;
            @(negedge clk); data_in = 0; shift = 0;
            @(negedge clk); data_in = 0; shift = 0;
            @(negedge clk); data_in = 0; shift = 0;

            @(negedge clk); shift = 1;
            repeat(2) @(negedge clk);
            @(posedge clk); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Propagate MSB=0 across register", test_num);
            reset_dut();

            @(negedge clk); data_in = 0; shift = 0;
            @(negedge clk); data_in = 1; shift = 0;
            @(negedge clk); data_in = 1; shift = 0;
            @(negedge clk); data_in = 1; shift = 0;

            @(negedge clk); shift = 1;
            repeat(2) @(negedge clk);
            @(posedge clk); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify serial input replaces LSB when shift is low", test_num);
            reset_dut();

            @(negedge clk); data_in = 1; shift = 0;
            repeat(3) @(negedge clk);

            @(negedge clk); data_in = 0; shift = 0;
            @(posedge clk); #1;
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
        input expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%b",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b",
                         expected_q);
                $display("  Got:      q=%b",
                         q);
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
        $dumpvars(0,clk, data_in, shift, q);
    end

endmodule
