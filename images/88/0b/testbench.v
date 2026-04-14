`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] Address;
    reg MemRead;
    reg MemWrite;
    reg [31:0] WriteData;
    wire [31:0] ReadData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Address(Address),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .WriteData(WriteData),
        .ReadData(ReadData)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Write and Read from Address 0", test_num);
        Address = 7'd0;
        WriteData = 32'hA5A5_5A5A;
        MemWrite = 1;
        MemRead = 0;
        #10;
        MemWrite = 0;
        MemRead = 1;
        #10;
        #1;

        check_outputs(32'hA5A5_5A5A);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Write and Read from Address 127", test_num);
        Address = 7'd127;
        WriteData = 32'h1234_5678;
        MemWrite = 1;
        MemRead = 0;
        #10;
        MemWrite = 0;
        MemRead = 1;
        #10;
        #1;

        check_outputs(32'h1234_5678);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Verify data persistence at Address 0 after other writes", test_num);

        Address = 7'd10;
        WriteData = 32'hDEAD_BEEF;
        MemWrite = 1;
        MemRead = 0;
        #10;
        MemWrite = 0;

        Address = 7'd0;
        MemRead = 1;
        #10;
        #1;

        check_outputs(32'hA5A5_5A5A);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Overwriting existing data at Address 10", test_num);
        Address = 7'd10;
        WriteData = 32'hCAFE_BABE;
        MemWrite = 1;
        MemRead = 0;
        #10;
        MemWrite = 0;
        MemRead = 1;
        #10;
        #1;

        check_outputs(32'hCAFE_BABE);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Write and Read all ones", test_num);
        Address = 7'd64;
        WriteData = 32'hFFFF_FFFF;
        MemWrite = 1;
        MemRead = 0;
        #10;
        MemWrite = 0;
        MemRead = 1;
        #10;
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Write and Read all zeros", test_num);
        Address = 7'd32;
        WriteData = 32'h0000_0000;
        MemWrite = 1;
        MemRead = 0;
        #10;
        MemWrite = 0;
        MemRead = 1;
        #10;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Verify Address 127 still holds correct value", test_num);
        Address = 7'd127;
        MemWrite = 0;
        MemRead = 1;
        #10;
        #1;

        check_outputs(32'h1234_5678);
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
        input [31:0] expected_ReadData;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ReadData === (expected_ReadData ^ ReadData ^ expected_ReadData)) begin
                $display("PASS");
                $display("  Outputs: ReadData=%h",
                         ReadData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ReadData=%h",
                         expected_ReadData);
                $display("  Got:      ReadData=%h",
                         ReadData);
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
