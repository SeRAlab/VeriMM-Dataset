`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [55:0] cd;
    wire [47:0] k;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cd(cd),
        .k(k)
    );
    task testcase001;

    begin
        $display("Test Case 001: All Zeros");
        cd = 56'h00000000000000;
        #1;

        check_outputs(48'h000000000000);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: All Ones");
        cd = 56'hFFFFFFFFFFFFFF;
        #1;

        check_outputs(48'hFFFFFFFFFFFF);
    end
        endtask

    task testcase003;

    begin



        $display("Test Case 003: Input bit 0 only (maps to k[4])");
        cd = 56'h80000000000000;
        #1;

        check_outputs(48'h080000000000);
    end
        endtask

    task testcase004;

    begin




        $display("Test Case 004: Input bit 13 only (maps to k[0])");
        cd = 56'h00040000000000;
        #1;

        check_outputs(48'h800000000000);
    end
        endtask

    task testcase005;

    begin




        $display("Test Case 005: Input bit 31 only (maps to k[47])");
        cd = 56'h00000001000000;
        #1;

        check_outputs(48'h000000000001);
    end
        endtask

    task testcase006;

    begin



        $display("Test Case 006: Input bit 55 only (maps to k[39])");
        cd = 56'h00000000000001;
        #1;

        check_outputs(48'h000000000100);
    end
        endtask

    task testcase007;

    begin



        $display("Test Case 007: Patterned Input");
        cd = 56'h0123456789ABCD;
        #1;

        check_outputs(48'h3180E8BB7569);
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
        input [47:0] expected_k;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_k === (expected_k ^ k ^ expected_k)) begin
                $display("PASS");
                $display("  Outputs: k=%h",
                         k);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: k=%h",
                         expected_k);
                $display("  Got:      k=%h",
                         k);
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
