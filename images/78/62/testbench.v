`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock_50;
    reg clock_recovery;
    reg [13:0] data_rec;
    reg reset_n;
    wire [13:0] data_stand;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock_50(clock_50),
        .clock_recovery(clock_recovery),
        .data_rec(data_rec),
        .reset_n(reset_n),
        .data_stand(data_stand)
    );

    // Clock generation (10ns period)
    initial begin
        clock_50 = 0;
        forever #5 clock_50 = ~clock_50;
    end

        task reset_dut;

    begin
        reset_n = 0;
        clock_recovery = 0;
        data_rec = 14'h0;
        @(negedge clock_50);
        reset_n = 1;
        @(posedge clock_50);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Initialization Check", test_num);
        reset_dut();

        #1;


        check_outputs(14'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Data Update with Clock Recovery Active", test_num);
        reset_dut();

        @(negedge clock_50);
        clock_recovery = 1;
        data_rec = 14'h1234;

        @(posedge clock_50);
        #2;
        #1;

        check_outputs(14'h1234);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Data Hold with Clock Recovery Inactive", test_num);
        reset_dut();


        @(negedge clock_50);
        clock_recovery = 1;
        data_rec = 14'h2AAA;
        @(posedge clock_50);
        #2;


        @(negedge clock_50);
        clock_recovery = 0;
        data_rec = 14'h3FFF;
        @(posedge clock_50);
        #2;

        #1;


        check_outputs(14'h2AAA);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Recovery Re-activation Check", test_num);
        reset_dut();


        @(negedge clock_50);
        clock_recovery = 1;
        data_rec = 14'h0555;
        @(posedge clock_50);
        #2;


        @(negedge clock_50);
        clock_recovery = 0;
        data_rec = 14'h1111;
        @(posedge clock_50);
        #2;


        @(negedge clock_50);
        clock_recovery = 1;
        data_rec = 14'h2222;
        @(posedge clock_50);
        #2;

        #1;


        check_outputs(14'h2222);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max and Min Value Sampling", test_num);
        reset_dut();


        @(negedge clock_50);
        clock_recovery = 1;
        data_rec = 14'h3FFF;
        @(posedge clock_50);
        #2;


        @(negedge clock_50);
        data_rec = 14'h0000;
        @(posedge clock_50);
        #2;

        #1;


        check_outputs(14'h0000);
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
        input [13:0] expected_data_stand;
        begin
            if (expected_data_stand === (expected_data_stand ^ data_stand ^ expected_data_stand)) begin
                $display("PASS");
                $display("  Outputs: data_stand=%h",
                         data_stand);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_stand=%h",
                         expected_data_stand);
                $display("  Got:      data_stand=%h",
                         data_stand);
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
        $dumpvars(0,clock_50, clock_recovery, data_rec, reset_n, data_stand);
    end

endmodule
