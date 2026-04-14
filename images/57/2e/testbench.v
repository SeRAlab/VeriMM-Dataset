`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] AluData;
    reg Halt;
    reg MemToReg;
    reg [15:0] MemoryData;
    wire [15:0] WriteData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AluData(AluData),
        .Halt(Halt),
        .MemToReg(MemToReg),
        .MemoryData(MemoryData),
        .WriteData(WriteData)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select AluData (MemToReg = 0) - Pattern AAAA", test_num);
            AluData = 16'hAAAA;
            MemoryData = 16'h5555;
            MemToReg = 1'b0;
            Halt = 1'b0;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select MemoryData (MemToReg = 1) - Pattern 5555", test_num);
            AluData = 16'hAAAA;
            MemoryData = 16'h5555;
            MemToReg = 1'b1;
            Halt = 1'b0;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select AluData (MemToReg = 0) - All Ones", test_num);
            AluData = 16'hFFFF;
            MemoryData = 16'h0000;
            MemToReg = 1'b0;
            Halt = 1'b0;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select MemoryData (MemToReg = 1) - All Ones", test_num);
            AluData = 16'h0000;
            MemoryData = 16'hFFFF;
            MemToReg = 1'b1;
            Halt = 1'b0;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select AluData (MemToReg = 0) - All Zeros", test_num);
            AluData = 16'h0000;
            MemoryData = 16'hFFFF;
            MemToReg = 1'b0;
            Halt = 1'b0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select MemoryData (MemToReg = 1) - All Zeros", test_num);
            AluData = 16'hFFFF;
            MemoryData = 16'h0000;
            MemToReg = 1'b1;
            Halt = 1'b0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Pattern - Select AluData", test_num);
            AluData = 16'h1234;
            MemoryData = 16'hABCD;
            MemToReg = 1'b0;
            Halt = 1'b0;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Pattern - Select MemoryData", test_num);
            AluData = 16'h1234;
            MemoryData = 16'hABCD;
            MemToReg = 1'b1;
            Halt = 1'b1;
            #1;

            check_outputs(16'hABCD);
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
        input [15:0] expected_WriteData;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_WriteData === (expected_WriteData ^ WriteData ^ expected_WriteData)) begin
                $display("PASS");
                $display("  Outputs: WriteData=%h",
                         WriteData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: WriteData=%h",
                         expected_WriteData);
                $display("  Got:      WriteData=%h",
                         WriteData);
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
