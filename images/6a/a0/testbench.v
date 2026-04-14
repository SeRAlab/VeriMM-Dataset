`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ALUSrcE;
    reg [31:0] RD2_outE;
    reg [15:0] extend_out;
    wire [31:0] SrcBE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUSrcE(ALUSrcE),
        .RD2_outE(RD2_outE),
        .extend_out(extend_out),
        .SrcBE(SrcBE)
    );
    task testcase001;

    begin
        test_num = 1;
        ALUSrcE = 1'b0;
        RD2_outE = 32'hA5A5_5A5A;
        extend_out = 16'h1234;
        #10;
        $display("Testcase 001: ALUSrcE=0, Select RD2_outE");
        #1;

        check_outputs(32'hA5A5_5A5A);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        ALUSrcE = 1'b0;
        RD2_outE = 32'hFFFF_FFFF;
        extend_out = 16'h0000;
        #10;
        $display("Testcase 002: ALUSrcE=0, Select RD2_outE (All ones)");
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        ALUSrcE = 1'b1;
        RD2_outE = 32'h1234_5678;
        extend_out = 16'h7FFF;
        #10;
        $display("Testcase 003: ALUSrcE=1, extend_out positive sign extension");
        #1;

        check_outputs(32'h0000_7FFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        ALUSrcE = 1'b1;
        RD2_outE = 32'h1234_5678;
        extend_out = 16'h8000;
        #10;
        $display("Testcase 004: ALUSrcE=1, extend_out negative sign extension");
        #1;

        check_outputs(32'hFFFF_8000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        ALUSrcE = 1'b1;
        RD2_outE = 32'h0000_0000;
        extend_out = 16'hFFFF;
        #10;
        $display("Testcase 005: ALUSrcE=1, extend_out = 0xFFFF");
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        ALUSrcE = 1'b1;
        RD2_outE = 32'hFFFF_FFFF;
        extend_out = 16'h0000;
        #10;
        $display("Testcase 006: ALUSrcE=1, extend_out = 0x0000");
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        ALUSrcE = 1'b0;
        RD2_outE = 32'h1122_3344;
        extend_out = 16'h8ABC;
        #10;
        $display("Testcase 007: Switching ALUSrcE 1 -> 0");
        #1;

        check_outputs(32'h1122_3344);
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
        input [31:0] expected_SrcBE;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_SrcBE === (expected_SrcBE ^ SrcBE ^ expected_SrcBE)) begin
                $display("PASS");
                $display("  Outputs: SrcBE=%h",
                         SrcBE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SrcBE=%h",
                         expected_SrcBE);
                $display("  Got:      SrcBE=%h",
                         SrcBE);
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
