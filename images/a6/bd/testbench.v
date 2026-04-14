`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] instr;
    reg [31:0] regs;
    reg [31:0] regt;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .instr(instr),
        .regs(regs),
        .regt(regt),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        instr = 32'h00000142;
        regs  = 32'hFFFFFFFF;
        regt  = 32'h55555555;
        $display("Test %0d: SRL (regt >> 5)", test_num);
        #1;

        check_outputs(32'h02AAAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        instr = 32'h00000002;
        regs  = 32'h00000000;
        regt  = 32'h12345678;
        $display("Test %0d: SRL (regt >> 0)", test_num);
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        instr = 32'h00000006;
        regs  = 32'h00000004;
        regt  = 32'hAAAA5555;
        $display("Test %0d: SRLV (regt >> regs[4:0]=4)", test_num);
        #1;

        check_outputs(32'h0AAAA555);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        instr = 32'h00000006;
        regs  = 32'h0000001F;
        regt  = 32'hFFFFFFFF;
        $display("Test %0d: SRLV (regt >> regs[4:0]=31)", test_num);
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        instr = 32'h34002222;
        regs  = 32'h00001111;
        regt  = 32'h00000000;
        $display("Test %0d: ORI (regs | 0x2222)", test_num);
        #1;

        check_outputs(32'h00003333);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        instr = 32'h34008000;
        regs  = 32'h00001111;
        regt  = 32'h00000000;
        $display("Test %0d: ORI (regs | sign_extended(0x8000))", test_num);

        #1;


        check_outputs(32'hFFFF9111);
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
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
