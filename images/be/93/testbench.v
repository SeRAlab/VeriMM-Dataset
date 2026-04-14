`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [35:0] DataFromMemoryIn0;
    reg [35:0] DataFromMemoryIn1;
    reg [35:0] DataToMemoryIn0;
    reg [35:0] DataToMemoryIn1;
    reg [9:0] ReadAddressIn0;
    reg [9:0] ReadAddressIn1;
    reg ReadEnable0;
    reg ReadEnable1;
    reg Select;
    reg [9:0] WriteAddressIn0;
    reg [9:0] WriteAddressIn1;
    reg WriteEnable0;
    reg WriteEnable1;
    wire [35:0] DataFromMemoryOut;
    wire [35:0] DataToMemoryOut;
    wire [9:0] ReadAddressOut;
    wire ReadEnable;
    wire [9:0] WriteAddressOut;
    wire WriteEnable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DataFromMemoryIn0(DataFromMemoryIn0),
        .DataFromMemoryIn1(DataFromMemoryIn1),
        .DataToMemoryIn0(DataToMemoryIn0),
        .DataToMemoryIn1(DataToMemoryIn1),
        .ReadAddressIn0(ReadAddressIn0),
        .ReadAddressIn1(ReadAddressIn1),
        .ReadEnable0(ReadEnable0),
        .ReadEnable1(ReadEnable1),
        .Select(Select),
        .WriteAddressIn0(WriteAddressIn0),
        .WriteAddressIn1(WriteAddressIn1),
        .WriteEnable0(WriteEnable0),
        .WriteEnable1(WriteEnable1),
        .DataFromMemoryOut(DataFromMemoryOut),
        .DataToMemoryOut(DataToMemoryOut),
        .ReadAddressOut(ReadAddressOut),
        .ReadEnable(ReadEnable),
        .WriteAddressOut(WriteAddressOut),
        .WriteEnable(WriteEnable)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Set 0", test_num);


        Select = 1'b0;
        ReadAddressIn0 = 10'h0AA;
        ReadAddressIn1 = 10'h3FF;
        WriteAddressIn0 = 10'h2BB;
        WriteAddressIn1 = 10'h111;
        DataToMemoryIn0 = 36'hA5A5A5A5A;
        DataToMemoryIn1 = 36'h5A5A5A5A5;
        DataFromMemoryIn0 = 36'h123456789;
        DataFromMemoryIn1 = 36'h987654321;
        ReadEnable0 = 1'b1;
        ReadEnable1 = 1'b0;
        WriteEnable0 = 1'b0;
        WriteEnable1 = 1'b1;


        #1;



        check_outputs(36'h123456789, 36'hA5A5A5A5A, 10'h0AA, 1'b1, 10'h2BB, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Set 1", test_num);


        Select = 1'b1;
        ReadAddressIn0 = 10'h0AA;
        ReadAddressIn1 = 10'h3FF;
        WriteAddressIn0 = 10'h2BB;
        WriteAddressIn1 = 10'h111;
        DataToMemoryIn0 = 36'hA5A5A5A5A;
        DataToMemoryIn1 = 36'h5A5A5A5A5;
        DataFromMemoryIn0 = 36'h123456789;
        DataFromMemoryIn1 = 36'h987654321;
        ReadEnable0 = 1'b1;
        ReadEnable1 = 1'b0;
        WriteEnable0 = 1'b0;
        WriteEnable1 = 1'b1;


        #1;



        check_outputs(36'h987654321, 36'h5A5A5A5A5, 10'h3FF, 1'b0, 10'h111, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Set 0 (Zero inputs)", test_num);

        Select = 1'b0;
        ReadAddressIn0 = 10'b0;
        ReadAddressIn1 = 10'h3FF;
        WriteAddressIn0 = 10'b0;
        WriteAddressIn1 = 10'h3FF;
        DataToMemoryIn0 = 36'b0;
        DataToMemoryIn1 = 36'hFFFFFFFFF;
        DataFromMemoryIn0 = 36'b0;
        DataFromMemoryIn1 = 36'hFFFFFFFFF;
        ReadEnable0 = 1'b0;
        ReadEnable1 = 1'b1;
        WriteEnable0 = 1'b0;
        WriteEnable1 = 1'b1;

        #1;


        check_outputs(36'b0, 36'b0, 10'b0, 1'b0, 10'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Set 1 (One inputs)", test_num);

        Select = 1'b1;
        ReadAddressIn0 = 10'b0;
        ReadAddressIn1 = 10'h3FF;
        WriteAddressIn0 = 10'b0;
        WriteAddressIn1 = 10'h3FF;
        DataToMemoryIn0 = 36'b0;
        DataToMemoryIn1 = 36'hFFFFFFFFF;
        DataFromMemoryIn0 = 36'b0;
        DataFromMemoryIn1 = 36'hFFFFFFFFF;
        ReadEnable0 = 1'b0;
        ReadEnable1 = 1'b1;
        WriteEnable0 = 1'b0;
        WriteEnable1 = 1'b1;

        #1;


        check_outputs(36'hFFFFFFFFF, 36'hFFFFFFFFF, 10'h3FF, 1'b1, 10'h3FF, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data integrity check", test_num);

        Select = 1'b0;
        ReadAddressIn0 = 10'h2AA;
        ReadAddressIn1 = 10'h155;
        WriteAddressIn0 = 10'h155;
        WriteAddressIn1 = 10'h2AA;
        DataToMemoryIn0 = 36'h12345ABCD;
        DataToMemoryIn1 = 36'hFEDCBA987;
        DataFromMemoryIn0 = 36'h67890BCDE;
        DataFromMemoryIn1 = 36'hEDCBA0987;
        ReadEnable0 = 1'b1;
        ReadEnable1 = 1'b1;
        WriteEnable0 = 1'b1;
        WriteEnable1 = 1'b1;

        #1;


        check_outputs(36'h67890BCDE, 36'h12345ABCD, 10'h2AA, 1'b1, 10'h155, 1'b1);
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
        input [35:0] expected_DataFromMemoryOut;
        input [35:0] expected_DataToMemoryOut;
        input [9:0] expected_ReadAddressOut;
        input expected_ReadEnable;
        input [9:0] expected_WriteAddressOut;
        input expected_WriteEnable;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DataFromMemoryOut === (expected_DataFromMemoryOut ^ DataFromMemoryOut ^ expected_DataFromMemoryOut) &&
                expected_DataToMemoryOut === (expected_DataToMemoryOut ^ DataToMemoryOut ^ expected_DataToMemoryOut) &&
                expected_ReadAddressOut === (expected_ReadAddressOut ^ ReadAddressOut ^ expected_ReadAddressOut) &&
                expected_ReadEnable === (expected_ReadEnable ^ ReadEnable ^ expected_ReadEnable) &&
                expected_WriteAddressOut === (expected_WriteAddressOut ^ WriteAddressOut ^ expected_WriteAddressOut) &&
                expected_WriteEnable === (expected_WriteEnable ^ WriteEnable ^ expected_WriteEnable)) begin
                $display("PASS");
                $display("  Outputs: DataFromMemoryOut=%h, DataToMemoryOut=%h, ReadAddressOut=%h, ReadEnable=%b, WriteAddressOut=%h, WriteEnable=%b",
                         DataFromMemoryOut, DataToMemoryOut, ReadAddressOut, ReadEnable, WriteAddressOut, WriteEnable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DataFromMemoryOut=%h, DataToMemoryOut=%h, ReadAddressOut=%h, ReadEnable=%b, WriteAddressOut=%h, WriteEnable=%b",
                         expected_DataFromMemoryOut, expected_DataToMemoryOut, expected_ReadAddressOut, expected_ReadEnable, expected_WriteAddressOut, expected_WriteEnable);
                $display("  Got:      DataFromMemoryOut=%h, DataToMemoryOut=%h, ReadAddressOut=%h, ReadEnable=%b, WriteAddressOut=%h, WriteEnable=%b",
                         DataFromMemoryOut, DataToMemoryOut, ReadAddressOut, ReadEnable, WriteAddressOut, WriteEnable);
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
