`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] aluResult;
    reg jal;
    reg [15:0] memData;
    reg memRe;
    reg [15:0] pcNext;
    reg [3:0] regAddr;
    reg regWe;
    wire [3:0] writeAddr;
    wire [15:0] writeData;
    wire writeEnable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aluResult(aluResult),
        .jal(jal),
        .memData(memData),
        .memRe(memRe),
        .pcNext(pcNext),
        .regAddr(regAddr),
        .regWe(regWe),
        .writeAddr(writeAddr),
        .writeData(writeData),
        .writeEnable(writeEnable)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: JAL instruction", test_num);
            jal = 1'b1;
            memRe = 1'b0;
            regWe = 1'b1;
            regAddr = 4'h5;
            pcNext = 16'h1234;
            memData = 16'h5678;
            aluResult = 16'h9ABC;
            #1;

            check_outputs(4'h5, 16'h1234, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Memory Read instruction", test_num);
            jal = 1'b0;
            memRe = 1'b1;
            regWe = 1'b1;
            regAddr = 4'hA;
            pcNext = 16'h0004;
            memData = 16'hDEAD;
            aluResult = 16'hBEEF;
            #1;

            check_outputs(4'hA, 16'hDEAD, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: ALU operation", test_num);
            jal = 1'b0;
            memRe = 1'b0;
            regWe = 1'b1;
            regAddr = 4'h3;
            pcNext = 16'hAAAA;
            memData = 16'hBBBB;
            aluResult = 16'hCCCC;
            #1;

            check_outputs(4'h3, 16'hCCCC, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write Enable Low", test_num);
            jal = 1'b0;
            memRe = 1'b0;
            regWe = 1'b0;
            regAddr = 4'hF;
            pcNext = 16'h1111;
            memData = 16'h2222;
            aluResult = 16'h3333;
            #1;

            check_outputs(4'hF, 16'h3333, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: JAL priority over MemRe", test_num);
            jal = 1'b1;
            memRe = 1'b1;
            regWe = 1'b1;
            regAddr = 4'h0;
            pcNext = 16'hFEDC;
            memData = 16'hBA98;
            aluResult = 16'h7654;
            #1;

            check_outputs(4'h0, 16'hFEDC, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Register Address mapping", test_num);
            jal = 1'b0;
            memRe = 1'b1;
            regWe = 1'b1;
            regAddr = 4'h7;
            pcNext = 16'h0;
            memData = 16'hFFFF;
            aluResult = 16'h0;
            #1;

            check_outputs(4'h7, 16'hFFFF, 1'b1);
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
        input [3:0] expected_writeAddr;
        input [15:0] expected_writeData;
        input expected_writeEnable;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_writeAddr === (expected_writeAddr ^ writeAddr ^ expected_writeAddr) &&
                expected_writeData === (expected_writeData ^ writeData ^ expected_writeData) &&
                expected_writeEnable === (expected_writeEnable ^ writeEnable ^ expected_writeEnable)) begin
                $display("PASS");
                $display("  Outputs: writeAddr=%h, writeData=%h, writeEnable=%b",
                         writeAddr, writeData, writeEnable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: writeAddr=%h, writeData=%h, writeEnable=%b",
                         expected_writeAddr, expected_writeData, expected_writeEnable);
                $display("  Got:      writeAddr=%h, writeData=%h, writeEnable=%b",
                         writeAddr, writeData, writeEnable);
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
