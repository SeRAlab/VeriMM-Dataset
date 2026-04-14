`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg ALUSrcA;
    reg [31:0] Pc;
    wire [31:0] muxout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .ALUSrcA(ALUSrcA),
        .Pc(Pc),
        .muxout(muxout)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: ALUSrcA=1, Select A (All Fs)", test_num);
        A = 32'hFFFFFFFF;
        Pc = 32'h00000000;
        ALUSrcA = 1'b1;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: ALUSrcA=0, Select Pc (All 0s)", test_num);
        A = 32'hFFFFFFFF;
        Pc = 32'h00000000;
        ALUSrcA = 1'b0;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: ALUSrcA=1, Select A (Alternating Bits)", test_num);
        A = 32'h55555555;
        Pc = 32'hAAAAAAAA;
        ALUSrcA = 1'b1;
        #1;

        check_outputs(32'h55555555);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: ALUSrcA=0, Select Pc (Alternating Bits)", test_num);
        A = 32'h55555555;
        Pc = 32'hAAAAAAAA;
        ALUSrcA = 1'b0;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: ALUSrcA=1, Select A (Mixed Pattern)", test_num);
        A = 32'h12345678;
        Pc = 32'h87654321;
        ALUSrcA = 1'b1;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: ALUSrcA=0, Select Pc (Mixed Pattern)", test_num);
        A = 32'hDEADBEEF;
        Pc = 32'hCAFEBABE;
        ALUSrcA = 1'b0;
        #1;

        check_outputs(32'hCAFEBABE);
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
        input [31:0] expected_muxout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_muxout === (expected_muxout ^ muxout ^ expected_muxout)) begin
                $display("PASS");
                $display("  Outputs: muxout=%h",
                         muxout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: muxout=%h",
                         expected_muxout);
                $display("  Got:      muxout=%h",
                         muxout);
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
