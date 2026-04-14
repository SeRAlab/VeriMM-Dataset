`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg data_in;
    wire clk_out;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in(clk_in),
        .data_in(data_in),
        .clk_out(clk_out),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

    begin
        data_in = 0;
        repeat(5) @(posedge clk_in);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase%03d: 0 to 1 Transition...", test_num);
        reset_dut();
        data_in = 1;


        repeat(20) @(posedge clk_in);
        #2;
        #1;

        check_outputs(clk_in, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase%03d: 1 to 0 Transition...", test_num);
        reset_dut();
        data_in = 1;
        repeat(10) @(posedge clk_in);
        data_in = 0;
        repeat(20) @(posedge clk_in);
        #2;
        #1;

        check_outputs(clk_in, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase%03d: Recovery from Unstable Input...", test_num);
        reset_dut();

        repeat(15) begin
            #3 data_in = ~data_in;
        end
        data_in = 1;
        repeat(30) @(posedge clk_in);
        #2;
        #1;

        check_outputs(clk_in, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase%03d: Sustained Stability...", test_num);
        reset_dut();
        data_in = 1;
        repeat(10) @(posedge clk_in);

        if (data_out !== 1'b1) $display("  Note: Synchronization still in progress or failed at cycle 10");

        repeat(50) @(posedge clk_in);
        #2;
        #1;

        check_outputs(clk_in, 1'b1);
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
        input expected_clk_out;
        input expected_data_out;
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b, data_out=%b",
                         clk_out, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b, data_out=%b",
                         expected_clk_out, expected_data_out);
                $display("  Got:      clk_out=%b, data_out=%b",
                         clk_out, data_out);
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
        $dumpvars(0,clk_in, data_in, clk_out, data_out);
    end

endmodule
