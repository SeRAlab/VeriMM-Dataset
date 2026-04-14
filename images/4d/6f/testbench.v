`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] so1x;
    reg [3:0] so2x;
    reg [3:0] so3x;
    reg [3:0] so4x;
    reg [3:0] so5x;
    reg [3:0] so6x;
    reg [3:0] so7x;
    reg [3:0] so8x;
    wire [31:0] ppo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .so1x(so1x),
        .so2x(so2x),
        .so3x(so3x),
        .so4x(so4x),
        .so5x(so5x),
        .so6x(so6x),
        .so7x(so7x),
        .so8x(so8x),
        .ppo(ppo)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Zeros", test_num);
        so1x = 4'h0; so2x = 4'h0; so3x = 4'h0; so4x = 4'h0;
        so5x = 4'h0; so6x = 4'h0; so7x = 4'h0; so8x = 4'h0;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Ones", test_num);
        so1x = 4'hF; so2x = 4'hF; so3x = 4'hF; so4x = 4'hF;
        so5x = 4'hF; so6x = 4'hF; so7x = 4'hF; so8x = 4'hF;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Sequential Nibbles 1-8", test_num);
        so1x = 4'h1; so2x = 4'h2; so3x = 4'h3; so4x = 4'h4;
        so5x = 4'h5; so6x = 4'h6; so7x = 4'h7; so8x = 4'h8;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Sequential Nibbles F-8", test_num);
        so1x = 4'hF; so2x = 4'hE; so3x = 4'hD; so4x = 4'hC;
        so5x = 4'hB; so6x = 4'hA; so7x = 4'h9; so8x = 4'h8;
        #1;

        check_outputs(32'hFEDCBA98);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Checkerboard Pattern A", test_num);
        so1x = 4'hA; so2x = 4'hA; so3x = 4'hA; so4x = 4'hA;
        so5x = 4'hA; so6x = 4'hA; so7x = 4'hA; so8x = 4'hA;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Checkerboard Pattern 5", test_num);
        so1x = 4'h5; so2x = 4'h5; so3x = 4'h5; so4x = 4'h5;
        so5x = 4'h5; so6x = 4'h5; so7x = 4'h5; so8x = 4'h5;
        #1;

        check_outputs(32'h55555555);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating Nibbles A/5", test_num);
        so1x = 4'hA; so2x = 4'h5; so3x = 4'hA; so4x = 4'h5;
        so5x = 4'hA; so6x = 4'h5; so7x = 4'hA; so8x = 4'h5;
        #1;

        check_outputs(32'hA5A5A5A5);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Walking Bit Pattern", test_num);
        so1x = 4'h8; so2x = 4'h4; so3x = 4'h2; so4x = 4'h1;
        so5x = 4'h8; so6x = 4'h4; so7x = 4'h2; so8x = 4'h1;
        #1;

        check_outputs(32'h84218421);
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
        input [31:0] expected_ppo;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ppo === (expected_ppo ^ ppo ^ expected_ppo)) begin
                $display("PASS");
                $display("  Outputs: ppo=%h",
                         ppo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ppo=%h",
                         expected_ppo);
                $display("  Got:      ppo=%h",
                         ppo);
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
