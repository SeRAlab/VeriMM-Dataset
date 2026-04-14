`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ALUout_M;
    reg [31:0] Data1;
    reg [31:0] Data2;
    reg [1:0] ForwardRSD;
    reg [1:0] ForwardRTD;
    reg [31:0] result_W;
    reg [31:0] result_WD;
    wire [31:0] D1;
    wire [31:0] D2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUout_M(ALUout_M),
        .Data1(Data1),
        .Data2(Data2),
        .ForwardRSD(ForwardRSD),
        .ForwardRTD(ForwardRTD),
        .result_W(result_W),
        .result_WD(result_WD),
        .D1(D1),
        .D2(D2)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: No Forwarding (Select original Data1 and Data2)");
            Data1 = 32'h1111_1111;
            Data2 = 32'h2222_2222;
            ALUout_M = 32'hAAAA_AAAA;
            result_W = 32'hBBBB_BBBB;
            result_WD = 32'hCCCC_CCCC;
            ForwardRSD = 2'b00;
            ForwardRTD = 2'b00;
            #1;

            check_outputs(32'h1111_1111, 32'h2222_2222);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Forward from Memory Stage (ALUout_M) to both ports");
            Data1 = 32'h1111_1111;
            Data2 = 32'h2222_2222;
            ALUout_M = 32'hAAAA_AAAA;
            result_W = 32'hBBBB_BBBB;
            result_WD = 32'hCCCC_CCCC;
            ForwardRSD = 2'b01;
            ForwardRTD = 2'b01;
            #1;

            check_outputs(32'hAAAA_AAAA, 32'hAAAA_AAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Forward from Write-Back Stage (result_W) to both ports");
            Data1 = 32'h1111_1111;
            Data2 = 32'h2222_2222;
            ALUout_M = 32'hAAAA_AAAA;
            result_W = 32'hBBBB_BBBB;
            result_WD = 32'hCCCC_CCCC;
            ForwardRSD = 2'b10;
            ForwardRTD = 2'b10;
            #1;

            check_outputs(32'hBBBB_BBBB, 32'hBBBB_BBBB);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Forward from Write-Back Data Source (result_WD) to both ports");
            Data1 = 32'h1111_1111;
            Data2 = 32'h2222_2222;
            ALUout_M = 32'hAAAA_AAAA;
            result_W = 32'hBBBB_BBBB;
            result_WD = 32'hCCCC_CCCC;
            ForwardRSD = 2'b11;
            ForwardRTD = 2'b11;
            #1;

            check_outputs(32'hCCCC_CCCC, 32'hCCCC_CCCC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Mixed Forwarding (D1: Memory Stage, D2: Write-Back Stage)");
            Data1 = 32'h1111_1111;
            Data2 = 32'h2222_2222;
            ALUout_M = 32'hAAAA_AAAA;
            result_W = 32'hBBBB_BBBB;
            result_WD = 32'hCCCC_CCCC;
            ForwardRSD = 2'b01;
            ForwardRTD = 2'b10;
            #1;

            check_outputs(32'hAAAA_AAAA, 32'hBBBB_BBBB);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Mixed Forwarding (D1: WD Result, D2: Original Data)");
            Data1 = 32'h1111_1111;
            Data2 = 32'h2222_2222;
            ALUout_M = 32'hAAAA_AAAA;
            result_W = 32'hBBBB_BBBB;
            result_WD = 32'hCCCC_CCCC;
            ForwardRSD = 2'b11;
            ForwardRTD = 2'b00;
            #1;

            check_outputs(32'hCCCC_CCCC, 32'h2222_2222);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Verify Data Independence (Changing Data Inputs)");
            Data1 = 32'hDEAD_BEEF;
            Data2 = 32'hCAFE_BABE;
            ALUout_M = 32'h8888_8888;
            result_W = 32'h9999_9999;
            result_WD = 32'hFFFF_FFFF;
            ForwardRSD = 2'b00;
            ForwardRTD = 2'b11;
            #1;

            check_outputs(32'hDEAD_BEEF, 32'hFFFF_FFFF);
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
        input [31:0] expected_D1;
        input [31:0] expected_D2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_D1 === (expected_D1 ^ D1 ^ expected_D1) &&
                expected_D2 === (expected_D2 ^ D2 ^ expected_D2)) begin
                $display("PASS");
                $display("  Outputs: D1=%h, D2=%h",
                         D1, D2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D1=%h, D2=%h",
                         expected_D1, expected_D2);
                $display("  Got:      D1=%h, D2=%h",
                         D1, D2);
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
