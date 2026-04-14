`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
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
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset State", test_num);
            reset = 1; req_0 = 0; req_1 = 0;
            @(posedge clock);
            #1;
            reset = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Grant 0 Activation", test_num);
            reset = 1; @(posedge clock); reset = 0;
            req_0 = 1; req_1 = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Grant 1 Activation", test_num);
            reset = 1; @(posedge clock); reset = 0;
            req_0 = 0; req_1 = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Priority req_0 over req_1", test_num);
            reset = 1; @(posedge clock); reset = 0;
            req_0 = 1; req_1 = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Hold Gnt_0 when Req_1 arrives", test_num);
            reset = 1; @(posedge clock); reset = 0;
            req_0 = 1; req_1 = 0;
            @(posedge clock);
            req_1 = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Release Req_0 to trigger Gnt_1", test_num);
            reset = 1; @(posedge clock); reset = 0;
            req_0 = 1; req_1 = 1;
            @(posedge clock);
            req_0 = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Hold Gnt_1 when Req_0 arrives", test_num);
            reset = 1; @(posedge clock); reset = 0;
            req_0 = 0; req_1 = 1;
            @(posedge clock);
            req_0 = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Release all requests returns to Idle", test_num);
            reset = 1; @(posedge clock); reset = 0;
            req_0 = 0; req_1 = 1;
            @(posedge clock);
            req_1 = 0;
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
        testcase008();
        
        
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
            #1; // Small delay for combinational logic to settle
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

endmodule
