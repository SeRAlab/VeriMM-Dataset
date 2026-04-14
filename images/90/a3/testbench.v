`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] Q1;
    reg [15:0] R1;
    reg [15:0] p;
    reg [15:0] x;
    wire [15:0] xD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Q1(Q1),
        .R1(R1),
        .p(p),
        .x(x),
        .xD(xD)
    );
    task testcase001;

    begin
        test_num = 1;
        p = 16'h0000;
        x = 16'h0000;
        R1 = 16'h0000;
        Q1 = 16'h0000;

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        p = 16'hFFFF;
        x = 16'hFFFF;
        R1 = 16'hFFFF;
        Q1 = 16'hFFFF;

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        p = 16'hFFFF;
        x = 16'h0000;
        R1 = 16'hAAAA;
        Q1 = 16'h5555;

        #1;


        check_outputs(16'hFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        p = 16'h0000;
        x = 16'h8001;
        R1 = 16'h0000;
        Q1 = 16'h0000;

        #1;


        check_outputs(16'h0003);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        p = 16'h5555;
        x = 16'h0000;
        R1 = 16'hFFFF;
        Q1 = 16'hFFFF;

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
        input [15:0] expected_xD;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_xD === (expected_xD ^ xD ^ expected_xD)) begin
                $display("PASS");
                $display("  Outputs: xD=%h",
                         xD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: xD=%h",
                         expected_xD);
                $display("  Got:      xD=%h",
                         xD);
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
