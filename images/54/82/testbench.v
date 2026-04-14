`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg start;
    wire complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .start(start),
        .complete(complete)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        start = 0;

        repeat(5) @(posedge clock);
        $display("Reset sequence completed.");
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Normal Sequence Execution", test_num);
        reset_dut();


        @(posedge clock);
        start = 1;
        @(posedge clock);
        start = 0;



        repeat(10) @(posedge clock);



        #1;




        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Start Signal Held High", test_num);
        reset_dut();

        @(posedge clock);
        start = 1;


        repeat(12) @(posedge clock);


        #1;



        check_outputs(1'b1);


        start = 0;
        repeat(2) @(posedge clock);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Start Pulse During Active Sequence", test_num);
        reset_dut();


        @(posedge clock);
        start = 1;
        @(posedge clock);
        start = 0;


        repeat(3) @(posedge clock);


        start = 1;
        @(posedge clock);
        start = 0;

        repeat(10) @(posedge clock);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Consecutive Sequences", test_num);
        reset_dut();


        @(posedge clock);
        start = 1;
        @(posedge clock);
        start = 0;
        repeat(10) @(posedge clock);


        @(posedge clock);
        start = 1;
        @(posedge clock);
        start = 0;
        repeat(10) @(posedge clock);

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
        input expected_complete;
        begin
            if (expected_complete === (expected_complete ^ complete ^ expected_complete)) begin
                $display("PASS");
                $display("  Outputs: complete=%b",
                         complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: complete=%b",
                         expected_complete);
                $display("  Got:      complete=%b",
                         complete);
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
        $dumpvars(0,clock, start, complete);
    end

endmodule
