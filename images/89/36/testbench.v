`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg en;
    reg [1:0] select;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .en(en),
        .select(select),
        .out(out)
    );
    task testcase001;

    begin
        $display("Testcase 001: en=1, select=00");
        en = 1'b1;
        select = 2'b00;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: en=1, select=11");
        en = 1'b1;
        select = 2'b11;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: en=0, select=00");
        en = 1'b0;
        select = 2'b00;
        #1;

        check_outputs(16'hFFFE);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: en=0, select=01");
        en = 1'b0;
        select = 2'b01;
        #1;

        check_outputs(16'hFFFD);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: en=0, select=10");
        en = 1'b0;
        select = 2'b10;
        #1;

        check_outputs(16'hFFFB);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: en=0, select=11");
        en = 1'b0;
        select = 2'b11;
        #1;

        check_outputs(16'hFFF7);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: en transition 0->1, select=10");
        en = 1'b0;
        select = 2'b10;
        #5;
        en = 1'b1;
        #1;

        check_outputs(16'hFFFF);
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
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
