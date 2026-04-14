`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] req;
    reg [3:0] src;
    wire grant;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .req(req),
        .src(src),
        .grant(grant)
    );
    task testcase001;

    begin
        $display("\nTestcase 001: No requests active");
        test_num = 1;
        req = 4'b0000;
        src = 4'b0001;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("\nTestcase 002: Single request at bit 0, checking bit 0");
        test_num = 2;
        req = 4'b0001;
        src = 4'b0001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("\nTestcase 003: Single request at bit 3, checking bit 3");
        test_num = 3;
        req = 4'b1000;
        src = 4'b1000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("\nTestcase 004: All bits requesting, checking highest priority (bit 0)");
        test_num = 4;
        req = 4'b1111;
        src = 4'b0001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("\nTestcase 005: All bits requesting, checking lower priority (bit 1)");
        test_num = 5;
        req = 4'b1111;
        src = 4'b0010;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        $display("\nTestcase 006: All bits requesting, checking lowest priority (bit 3)");
        test_num = 6;
        req = 4'b1111;
        src = 4'b1000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        $display("\nTestcase 007: Contention between bit 1 and bit 2, checking bit 1");
        test_num = 7;
        req = 4'b0110;
        src = 4'b0010;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        $display("\nTestcase 008: Contention between bit 1 and bit 2, checking bit 2");
        test_num = 8;
        req = 4'b0110;
        src = 4'b0100;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        $display("\nTestcase 009: Check bit that is not requesting");
        test_num = 9;
        req = 4'b1011;
        src = 4'b0100;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        $display("\nTestcase 010: Contention between bit 0 and bit 3, checking bit 3");
        test_num = 10;
        req = 4'b1001;
        src = 4'b1000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase011;

    begin
        $display("\nTestcase 011: Source bit mismatch with request");
        test_num = 11;
        req = 4'b0010;
        src = 4'b1000;
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        
        
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
            #1; // Small delay for combinational logic to settle
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

endmodule
