`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ALUSrc;
    reg [31:0] Extended;
    reg [31:0] RData2;
    wire [31:0] ALUB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUSrc(ALUSrc),
        .Extended(Extended),
        .RData2(RData2),
        .ALUB(ALUB)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select RData2", test_num);
        ALUSrc = 1'b0;
        RData2 = 32'h12345678;
        Extended = 32'h87654321;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Extended", test_num);
        ALUSrc = 1'b1;
        RData2 = 32'h12345678;
        Extended = 32'h87654321;
        #1;

        check_outputs(32'h87654321);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select RData2 (All Fs)", test_num);
        ALUSrc = 1'b0;
        RData2 = 32'hFFFFFFFF;
        Extended = 32'h00000000;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Extended (All Fs)", test_num);
        ALUSrc = 1'b1;
        RData2 = 32'h00000000;
        Extended = 32'hFFFFFFFF;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select RData2 (Alternating bits)", test_num);
        ALUSrc = 1'b0;
        RData2 = 32'hAAAAAAAA;
        Extended = 32'h55555555;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Extended (Alternating bits)", test_num);
        ALUSrc = 1'b1;
        RData2 = 32'hAAAAAAAA;
        Extended = 32'h55555555;
        #1;

        check_outputs(32'h55555555);
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
        input [31:0] expected_ALUB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUB === (expected_ALUB ^ ALUB ^ expected_ALUB)) begin
                $display("PASS");
                $display("  Outputs: ALUB=%h",
                         ALUB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUB=%h",
                         expected_ALUB);
                $display("  Got:      ALUB=%h",
                         ALUB);
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
