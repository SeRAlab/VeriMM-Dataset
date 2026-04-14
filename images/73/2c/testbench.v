`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] CRC;
    reg [15:0] Data;
    wire [15:0] NewCRC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CRC(CRC),
        .Data(Data),
        .NewCRC(NewCRC)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: All Zeros");
        Data = 16'h0000;
        CRC  = 16'h0000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Single bit (LSB) in Data");
        Data = 16'h0001;
        CRC  = 16'h0000;
        #1;

        check_outputs(16'h1021);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Single bit (LSB) in existing CRC");
        Data = 16'h0000;
        CRC  = 16'h0001;
        #1;

        check_outputs(16'h1021);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Single bit (MSB) in Data");
        Data = 16'h8000;
        CRC  = 16'h0000;
        #1;

        check_outputs(16'h8408);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: All bits set in Data");
        Data = 16'hFFFF;
        CRC  = 16'h0000;
        #1;

        check_outputs(16'h1EF0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: All bits set in existing CRC");
        Data = 16'h0000;
        CRC  = 16'hFFFF;
        #1;

        check_outputs(16'h1EF0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: Standard pattern 0x1234");
        Data = 16'h1234;
        CRC  = 16'h0000;
        #1;

        check_outputs(16'h1351);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case 008: Data 0x1234 with CRC 0x5678");
        Data = 16'h1234;
        CRC  = 16'h5678;
        #1;

        check_outputs(16'h5C81);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case 009: Symmetry (Data^CRC resulting in 0xFFFF)");
        Data = 16'hAAAA;
        CRC  = 16'h5555;
        #1;

        check_outputs(16'h1EF0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case 010: Data equals CRC (Result should be 0)");
        Data = 16'hABCD;
        CRC  = 16'hABCD;
        #1;

        check_outputs(16'h0000);
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
        input [15:0] expected_NewCRC;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_NewCRC === (expected_NewCRC ^ NewCRC ^ expected_NewCRC)) begin
                $display("PASS");
                $display("  Outputs: NewCRC=%h",
                         NewCRC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: NewCRC=%h",
                         expected_NewCRC);
                $display("  Got:      NewCRC=%h",
                         NewCRC);
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
