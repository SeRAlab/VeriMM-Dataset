`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg mem_rd;
    reg mem_wr;
    reg [3:0] req;
    wire grant;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .mem_rd(mem_rd),
        .mem_wr(mem_wr),
        .req(req),
        .grant(grant)
    );

    // Clock generation (10ns period)
    initial begin
        mem_rd = 0;
        forever #5 mem_rd = ~mem_rd;
    end

        task reset_dut;

        begin
            mem_wr = 0;
            req = 4'b0000;

            repeat(2) @(posedge mem_rd);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No requests, idle state.", test_num);
            reset_dut();
            req = 4'b0000;
            mem_wr = 0;
            repeat(2) @(posedge mem_rd);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single requester bit 0 active.", test_num);
            reset_dut();
            req = 4'b0001;
            mem_wr = 0;
            @(posedge mem_rd);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write operation with req bit 2.", test_num);
            reset_dut();
            req = 4'b0100;
            mem_wr = 1;
            @(posedge mem_rd);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple requests (round-robin check).", test_num);
            reset_dut();
            req = 4'b1011;
            mem_wr = 1;
            @(posedge mem_rd);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Grant via Read clocking.", test_num);
            reset_dut();
            req = 4'b1000;
            mem_wr = 0;
            @(posedge mem_rd);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Withdraw requests.", test_num);
            reset_dut();
            req = 4'b0011;
            mem_wr = 1;
            @(posedge mem_rd);
            #1;
            req = 4'b0000;
            @(posedge mem_rd);
            #1;
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
        input expected_grant;
        begin
            if (expected_grant === (expected_grant ^ grant ^ expected_grant)) begin
                $display("PASS");
                $display("  Outputs: grant=%b",
                         grant);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: grant=%b",
                         expected_grant);
                $display("  Got:      grant=%b",
                         grant);
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
        $dumpvars(0,mem_rd, mem_wr, req, grant);
    end

endmodule
