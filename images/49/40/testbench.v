`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] iData;
    reg [1:0] iEna;
    wire [7:0] oData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iData(iData),
        .iEna(iEna),
        .oData(oData)
    );
    task testcase001;

        begin
            $display("Testcase 001: Disable state - iEna = 00");
            iEna = 2'b00;
            iData = 3'b000;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Disable state - iEna = 01");
            iEna = 2'b01;
            iData = 3'b101;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Disable state - iEna = 11");
            iEna = 2'b11;
            iData = 3'b011;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Enabled - Decode 000");
            iEna = 2'b10;
            iData = 3'b000;
            #1;

            check_outputs(8'b1111_1110);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Enabled - Decode 001");
            iEna = 2'b10;
            iData = 3'b001;
            #1;

            check_outputs(8'b1111_1101);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Enabled - Decode 010");
            iEna = 2'b10;
            iData = 3'b010;
            #1;

            check_outputs(8'b1111_1011);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Enabled - Decode 011");
            iEna = 2'b10;
            iData = 3'b011;
            #1;

            check_outputs(8'b1111_0111);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Enabled - Decode 100");
            iEna = 2'b10;
            iData = 3'b100;
            #1;

            check_outputs(8'b1110_1111);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Enabled - Decode 101");
            iEna = 2'b10;
            iData = 3'b101;
            #1;

            check_outputs(8'b1101_1111);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Enabled - Decode 110");
            iEna = 2'b10;
            iData = 3'b110;
            #1;

            check_outputs(8'b1011_1111);
        end
        endtask

    task testcase011;

        begin
            $display("Testcase 011: Enabled - Decode 111");
            iEna = 2'b10;
            iData = 3'b111;
            #1;

            check_outputs(8'b0111_1111);
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
        input [7:0] expected_oData;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oData === (expected_oData ^ oData ^ expected_oData)) begin
                $display("PASS");
                $display("  Outputs: oData=%h",
                         oData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oData=%h",
                         expected_oData);
                $display("  Got:      oData=%h",
                         oData);
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
