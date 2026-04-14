`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] Address;
    reg MemWrite;
    reg [7:0] WriteData;
    reg ler;
    wire [7:0] ReadData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Address(Address),
        .MemWrite(MemWrite),
        .WriteData(WriteData),
        .ler(ler),
        .ReadData(ReadData)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Basic Write and Read at Address 0", test_num);

            Address = 32'd0;
            WriteData = 8'hAA;
            MemWrite = 1;
            ler = 0;
            #10;

            MemWrite = 0;
            ler = 1;
            #10;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Basic Write and Read at Address 500 (Upper Bound)", test_num);

            Address = 32'd500;
            WriteData = 8'h55;
            MemWrite = 1;
            ler = 0;
            #10;

            MemWrite = 0;
            ler = 1;
            #10;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Overwriting data at the same address", test_num);

            Address = 32'd100;
            WriteData = 8'h11;
            MemWrite = 1;
            ler = 0;
            #10;

            WriteData = 8'h22;
            #10;

            MemWrite = 0;
            ler = 1;
            #10;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Multiple writes, specific read back", test_num);

            Address = 32'd10; WriteData = 8'hA1; MemWrite = 1; ler = 0; #10;

            Address = 32'd20; WriteData = 8'hB2; MemWrite = 1; #10;

            Address = 32'd30; WriteData = 8'hC3; MemWrite = 1; #10;


            MemWrite = 0;
            Address = 32'd20;
            ler = 1;
            #10;
            #1;

            check_outputs(8'hB2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Write and Read at middle address 255", test_num);

            Address = 32'd255;
            WriteData = 8'hFF;
            MemWrite = 1;
            ler = 0;
            #10;

            MemWrite = 0;
            ler = 1;
            #10;
            #1;

            check_outputs(8'hFF);
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
        input [7:0] expected_ReadData;
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
