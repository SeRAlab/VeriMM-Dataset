`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg MemRead;
    reg [31:0] ninst;
    wire [31:0] inst;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .MemRead(MemRead),
        .ninst(ninst),
        .inst(inst)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Read Operation", test_num);

            MemRead = 1;
            ninst = 32'hA5A5_B6B6;
            #10;
            #1;

            check_outputs(32'hA5A5_B6B6);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Data Latching/Hold Behavior", test_num);

            MemRead = 1;
            ninst = 32'h1234_5678;
            #10;

            MemRead = 0;
            #5;

            ninst = 32'hFFFF_FFFF;
            #10;

            #1;


            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Continuous Read Flow", test_num);
            MemRead = 1;
            ninst = 32'h0000_0000;
            #5;
            ninst = 32'hCAFE_BABE;
            #5;
            ninst = 32'hDEAD_BEEF;
            #10;

            #1;


            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Hold and Resume Read", test_num);

            MemRead = 1;
            ninst = 32'h8888_9999;
            #10;

            MemRead = 0;
            ninst = 32'h1111_2222;
            #10;

            MemRead = 1;
            ninst = 32'h3333_4444;
            #10;
            #1;

            check_outputs(32'h3333_4444);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: All-Bits Toggle Test", test_num);
            MemRead = 1;
            ninst = 32'hFFFF_FFFF;
            #10;
            ninst = 32'h0000_0000;
            #10;
            #1;

            check_outputs(32'h0000_0000);
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
        input [31:0] expected_inst;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_inst === (expected_inst ^ inst ^ expected_inst)) begin
                $display("PASS");
                $display("  Outputs: inst=%h",
                         inst);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: inst=%h",
                         expected_inst);
                $display("  Got:      inst=%h",
                         inst);
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
