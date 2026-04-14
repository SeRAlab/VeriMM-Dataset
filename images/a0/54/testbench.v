`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Ctr;
    reg [15:0] imm_16;
    wire [31:0] imm_32;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Ctr(Ctr),
        .imm_16(imm_16),
        .imm_32(imm_32)
    );
    task testcase001;

    begin
        test_num = 1;
        Ctr = 1'b0;
        imm_16 = 16'h0005;
        #1;

        check_outputs(32'h00000005);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        Ctr = 1'b0;
        imm_16 = 16'h8001;
        #1;

        check_outputs(32'h00008001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        Ctr = 1'b0;
        imm_16 = 16'hFFFF;
        #1;

        check_outputs(32'h0000FFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        Ctr = 1'b1;
        imm_16 = 16'h7FFF;
        #1;

        check_outputs(32'h00007FFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        Ctr = 1'b1;
        imm_16 = 16'h8000;
        #1;

        check_outputs(32'hFFFF8000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        Ctr = 1'b1;
        imm_16 = 16'hFFFF;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        Ctr = 1'b1;
        imm_16 = 16'hA5A5;
        #1;

        check_outputs(32'hFFFFA5A5);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        Ctr = 1'b1;
        imm_16 = 16'h5A5A;
        #1;

        check_outputs(32'h00005A5A);
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
        input [31:0] expected_imm_32;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_imm_32 === (expected_imm_32 ^ imm_32 ^ expected_imm_32)) begin
                $display("PASS");
                $display("  Outputs: imm_32=%h",
                         imm_32);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: imm_32=%h",
                         expected_imm_32);
                $display("  Got:      imm_32=%h",
                         imm_32);
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
