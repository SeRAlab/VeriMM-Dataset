`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] D;
    wire [2:0] EN;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .EN(EN)
    );
    task testcase001;

    begin
        $display("Testcase 001: No bits set (Input: 00000000)");
        D = 8'b00000000;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Bit 0 set (Input: 00000001)");
        D = 8'b00000001;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Bit 1 set (Input: 00000010)");
        D = 8'b00000010;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Bit 2 set (Input: 00000100)");
        D = 8'b00000100;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Bit 3 set (Input: 00001000)");
        D = 8'b00001000;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Bit 4 set (Input: 00010000)");
        D = 8'b00010000;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Bit 5 set (Input: 00100000)");
        D = 8'b00100000;
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Bit 6 set (Input: 01000000)");
        D = 8'b01000000;
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: Bit 7 set (Input: 10000000)");
        D = 8'b10000000;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase010;

    begin
        $display("Testcase 010: Bit 7 and Bit 0 set (Input: 10000001)");
        D = 8'b10000001;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase011;

    begin
        $display("Testcase 011: Bits 4, 3, 2, 1 set (Input: 00011110)");
        D = 8'b00011110;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase012;

    begin
        $display("Testcase 012: All bits set (Input: 11111111)");
        D = 8'b11111111;
        #1;

        check_outputs(3'b111);
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
        testcase012();
        
        
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
        input [2:0] expected_EN;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EN === (expected_EN ^ EN ^ expected_EN)) begin
                $display("PASS");
                $display("  Outputs: EN=%h",
                         EN);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EN=%h",
                         expected_EN);
                $display("  Got:      EN=%h",
                         EN);
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
