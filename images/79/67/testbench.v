`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [10:0] Data;
    reg [4:0] crc;
    wire [4:0] nextCRC5_D11;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Data(Data),
        .crc(crc),
        .nextCRC5_D11(nextCRC5_D11)
    );
    task testcase001;

        begin
            $display("Testcase 001: Zero Data and Zero CRC");
            test_num = test_num + 1;
            Data = 11'h000;
            crc = 5'h00;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single bit set in Data (LSB)");
            test_num = test_num + 1;
            Data = 11'h001;
            crc = 5'h00;

            #1;


            check_outputs(5'h05);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Single bit set in CRC (LSB)");
            test_num = test_num + 1;
            Data = 11'h000;
            crc = 5'h01;

            #1;


            check_outputs(5'h07);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: All bits set in Data, zero CRC");
            test_num = test_num + 1;
            Data = 11'h7FF;
            crc = 5'h00;
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Zero Data, all bits set in CRC");
            test_num = test_num + 1;
            Data = 11'h000;
            crc = 5'h1F;
            #1;

            check_outputs(5'h14);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Alternating bits in Data");
            test_num = test_num + 1;
            Data = 11'h555;
            crc = 5'h00;
            #1;

            check_outputs(5'h0F);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Middle bits set in Data");
            test_num = test_num + 1;
            Data = 11'h070;
            crc = 5'h00;
            #1;

            check_outputs(5'h03);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: High bits set in Data and CRC");
            test_num = test_num + 1;
            Data = 11'h600;
            crc = 5'h18;
            #1;

            check_outputs(5'h0C);
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
        input [4:0] expected_nextCRC5_D11;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_nextCRC5_D11 === (expected_nextCRC5_D11 ^ nextCRC5_D11 ^ expected_nextCRC5_D11)) begin
                $display("PASS");
                $display("  Outputs: nextCRC5_D11=%h",
                         nextCRC5_D11);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nextCRC5_D11=%h",
                         expected_nextCRC5_D11);
                $display("  Got:      nextCRC5_D11=%h",
                         nextCRC5_D11);
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
