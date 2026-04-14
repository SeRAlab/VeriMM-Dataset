`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg req_0;
    reg req_1;
    reg reset;
    wire gnt_0;
    wire gnt_1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .req_0(req_0),
        .req_1(req_1),
        .reset(reset),
        .gnt_0(gnt_0),
        .gnt_1(gnt_1)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset = 1;
        req_0 = 0;
        req_1 = 0;
        @(posedge clock);
        #1 reset = 0;
        @(posedge clock);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Initial Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Request 0 only", test_num);
        reset_dut();
        req_0 = 1;
        req_1 = 0;
        @(posedge clock);
        #1;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Request 1 only", test_num);
        reset_dut();
        req_0 = 0;
        req_1 = 1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Priority check (Both req high from Idle)", test_num);
        reset_dut();
        req_0 = 1;
        req_1 = 1;
        @(posedge clock);
        #1;

        #1;


        check_outputs(1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Release Req 0 to grant Req 1", test_num);
        reset_dut();
        req_0 = 1;
        req_1 = 1;
        @(posedge clock);
        #1;
        req_0 = 0;
        @(posedge clock);
        #1;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Release Req 1 to grant Req 0", test_num);
        reset_dut();
        req_0 = 0;
        req_1 = 1;
        @(posedge clock);
        #1;
        req_0 = 1;
        @(posedge clock);
        #1;
        req_1 = 0;
        @(posedge clock);
        #1;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Release all to return to Idle", test_num);
        reset_dut();
        req_0 = 1;
        @(posedge clock);
        #1;
        req_0 = 0;
        @(posedge clock);
        #1;
        #1;

        check_outputs(0, 0);
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
        testcase007();
        
        
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
        input expected_gnt_0;
        input expected_gnt_1;
        begin
            if (expected_gnt_0 === (expected_gnt_0 ^ gnt_0 ^ expected_gnt_0) &&
                expected_gnt_1 === (expected_gnt_1 ^ gnt_1 ^ expected_gnt_1)) begin
                $display("PASS");
                $display("  Outputs: gnt_0=%b, gnt_1=%b",
                         gnt_0, gnt_1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gnt_0=%b, gnt_1=%b",
                         expected_gnt_0, expected_gnt_1);
                $display("  Got:      gnt_0=%b, gnt_1=%b",
                         gnt_0, gnt_1);
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
        $dumpvars(0,clock, req_0, req_1, reset, gnt_0, gnt_1);
    end

endmodule
