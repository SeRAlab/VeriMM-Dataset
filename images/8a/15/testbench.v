`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg key_in;
    wire key_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .key_in(key_in),
        .key_out(key_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        key_in = 1;
        repeat(5) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Initial state check", test_num);
        reset_dut();

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Noise rejection (short press glitch)", test_num);
        reset_dut();


        key_in = 0;
        repeat(1000) @(posedge clk);
        key_in = 1;
        repeat(100) @(posedge clk);


        #1;



        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sustained press (valid low transition)", test_num);
        reset_dut();


        key_in = 0;
        repeat(DEBOUNCE_LIMIT + 10) @(posedge clk);


        #1;



        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Noise rejection while key is already low", test_num);
        reset_dut();


        key_in = 0;
        repeat(DEBOUNCE_LIMIT + 10) @(posedge clk);


        key_in = 1;
        repeat(500) @(posedge clk);
        key_in = 0;
        repeat(100) @(posedge clk);


        #1;



        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sustained release (valid high transition)", test_num);
        reset_dut();


        key_in = 0;
        repeat(DEBOUNCE_LIMIT + 10) @(posedge clk);


        key_in = 1;
        repeat(DEBOUNCE_LIMIT + 10) @(posedge clk);


        #1;



        check_outputs(1'b1);
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
        input expected_key_out;
        begin
            if (expected_key_out === (expected_key_out ^ key_out ^ expected_key_out)) begin
                $display("PASS");
                $display("  Outputs: key_out=%b",
                         key_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: key_out=%b",
                         expected_key_out);
                $display("  Got:      key_out=%b",
                         key_out);
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
        $dumpvars(0,clk, key_in, key_out);
    end

endmodule
