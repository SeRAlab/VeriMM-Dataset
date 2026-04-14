`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] DIN;
    reg INIT;
    reg [2:0] IPOS;
    wire [2:0] OPOS;
    wire VALID;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DIN(DIN),
        .INIT(INIT),
        .IPOS(IPOS),
        .OPOS(OPOS),
        .VALID(VALID)
    );
    task testcase001;

    begin
        $display("Testcase 001: Detect lowest bit set at index 0");
        DIN = 8'b0000_0001;
        IPOS = 3'd0;
        INIT = 1'b0;
        #10;
        #1;

        check_outputs(3'd0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Detect highest bit set at index 7");
        DIN = 8'b1000_0000;
        IPOS = 3'd0;
        INIT = 1'b0;
        #10;
        #1;

        check_outputs(3'd7, 1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Multiple bits set, find the first one starting from IPOS=0");
        DIN = 8'b1010_1010;
        IPOS = 3'd0;
        INIT = 1'b0;
        #10;
        #1;

        check_outputs(3'd1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Multiple bits set, filter using IPOS offset (IPOS=2)");
        DIN = 8'b1010_1010;
        IPOS = 3'd2;
        INIT = 1'b0;
        #10;
        #1;

        check_outputs(3'd3, 1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Multiple bits set, filter using IPOS offset (IPOS=6)");
        DIN = 8'b1010_1010;
        IPOS = 3'd6;
        INIT = 1'b0;
        #10;
        #1;

        check_outputs(3'd7, 1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: IPOS exceeds all set bits (VALID should be 0)");
        DIN = 8'b0000_1111;
        IPOS = 3'd4;
        INIT = 1'b0;
        #10;

        #1;


        check_outputs(OPOS, 1'b0);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: No bits set in DIN (VALID should be 0)");
        DIN = 8'b0000_0000;
        IPOS = 3'd0;
        INIT = 1'b0;
        #10;
        #1;

        check_outputs(OPOS, 1'b0);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: INIT signal usage (Assuming INIT resets search to start from bit 0)");
        DIN = 8'b1010_1010;
        IPOS = 3'd4;
        INIT = 1'b1;
        #10;
        #1;

        check_outputs(3'd1, 1'b1);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: All bits set, check IPOS=7");
        DIN = 8'b1111_1111;
        IPOS = 3'd7;
        INIT = 1'b0;
        #10;
        #1;

        check_outputs(3'd7, 1'b1);
    end
        endtask

    task testcase010;

    begin
        $display("Testcase 010: Boundary check at IPOS=0 with INIT=0");
        DIN = 8'b0001_0000;
        IPOS = 3'd0;
        INIT = 1'b0;
        #10;
        #1;

        check_outputs(3'd4, 1'b1);
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
        input [2:0] expected_OPOS;
        input expected_VALID;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OPOS === (expected_OPOS ^ OPOS ^ expected_OPOS) &&
                expected_VALID === (expected_VALID ^ VALID ^ expected_VALID)) begin
                $display("PASS");
                $display("  Outputs: OPOS=%h, VALID=%b",
                         OPOS, VALID);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OPOS=%h, VALID=%b",
                         expected_OPOS, expected_VALID);
                $display("  Got:      OPOS=%h, VALID=%b",
                         OPOS, VALID);
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
