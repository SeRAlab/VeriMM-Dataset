`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [10:0] addr;
    reg en;
    reg [7:0] keypad;
    reg [31:0] msCount;
    wire [31:0] outputIO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .en(en),
        .keypad(keypad),
        .msCount(msCount),
        .outputIO(outputIO)
    );
    task testcase001;

    begin
        $display("Testcase 001: Read keypad value (Address 1, Enabled)");
        en = 1;
        addr = 11'd1;
        keypad = 8'hA5;
        msCount = 32'h12345678;
        #1;

        check_outputs(32'h000000A5);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Read millisecond counter (Address 2, Enabled)");
        en = 1;
        addr = 11'd2;
        keypad = 8'hFF;
        msCount = 32'hDEADBEEF;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Access keypad address while module is disabled");
        en = 0;
        addr = 11'd1;
        keypad = 8'h55;
        msCount = 32'h11112222;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Access counter address while module is disabled");
        en = 0;
        addr = 11'd2;
        keypad = 8'hAA;
        msCount = 32'h33334444;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Access invalid address (Address 3, Enabled)");
        en = 1;
        addr = 11'd3;
        keypad = 8'h01;
        msCount = 32'h55556666;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Access address 0 (Enabled)");
        en = 1;
        addr = 11'd0;
        keypad = 8'h02;
        msCount = 32'h77778888;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Verify keypad padding with zero high bits");
        en = 1;
        addr = 11'd1;
        keypad = 8'h80;
        msCount = 32'hFFFFFFFF;
        #1;

        check_outputs(32'h00000080);
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
        input [31:0] expected_outputIO;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outputIO === (expected_outputIO ^ outputIO ^ expected_outputIO)) begin
                $display("PASS");
                $display("  Outputs: outputIO=%h",
                         outputIO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outputIO=%h",
                         expected_outputIO);
                $display("  Got:      outputIO=%h",
                         outputIO);
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
