`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg RE;
    reg WE;
    wire RW;
    wire mem_ADV;
    wire mem_CE;
    wire mem_CRE;
    wire mem_LB;
    wire mem_OE;
    wire mem_UB;
    wire mem_WAIT;
    wire mem_WE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RE(RE),
        .WE(WE),
        .RW(RW),
        .mem_ADV(mem_ADV),
        .mem_CE(mem_CE),
        .mem_CRE(mem_CRE),
        .mem_LB(mem_LB),
        .mem_OE(mem_OE),
        .mem_UB(mem_UB),
        .mem_WAIT(mem_WAIT),
        .mem_WE(mem_WE)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Idle State (RE=0, WE=0)", test_num);
            RE = 0;
            WE = 0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Read Operation (RE=1, WE=0)", test_num);
            RE = 1;
            WE = 0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Write Operation (RE=0, WE=1)", test_num);
            RE = 0;
            WE = 1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simultaneous RE and WE (RE=1, WE=1)", test_num);
            RE = 1;
            WE = 1;


            #1;



            check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Return to Idle State (RE=0, WE=0)", test_num);
            RE = 0;
            WE = 0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1);
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
        input expected_RW;
        input expected_mem_ADV;
        input expected_mem_CE;
        input expected_mem_CRE;
        input expected_mem_LB;
        input expected_mem_OE;
        input expected_mem_UB;
        input expected_mem_WAIT;
        input expected_mem_WE;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RW === (expected_RW ^ RW ^ expected_RW) &&
                expected_mem_ADV === (expected_mem_ADV ^ mem_ADV ^ expected_mem_ADV) &&
                expected_mem_CE === (expected_mem_CE ^ mem_CE ^ expected_mem_CE) &&
                expected_mem_CRE === (expected_mem_CRE ^ mem_CRE ^ expected_mem_CRE) &&
                expected_mem_LB === (expected_mem_LB ^ mem_LB ^ expected_mem_LB) &&
                expected_mem_OE === (expected_mem_OE ^ mem_OE ^ expected_mem_OE) &&
                expected_mem_UB === (expected_mem_UB ^ mem_UB ^ expected_mem_UB) &&
                expected_mem_WAIT === (expected_mem_WAIT ^ mem_WAIT ^ expected_mem_WAIT) &&
                expected_mem_WE === (expected_mem_WE ^ mem_WE ^ expected_mem_WE)) begin
                $display("PASS");
                $display("  Outputs: RW=%b, mem_ADV=%b, mem_CE=%b, mem_CRE=%b, mem_LB=%b, mem_OE=%b, mem_UB=%b, mem_WAIT=%b, mem_WE=%b",
                         RW, mem_ADV, mem_CE, mem_CRE, mem_LB, mem_OE, mem_UB, mem_WAIT, mem_WE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RW=%b, mem_ADV=%b, mem_CE=%b, mem_CRE=%b, mem_LB=%b, mem_OE=%b, mem_UB=%b, mem_WAIT=%b, mem_WE=%b",
                         expected_RW, expected_mem_ADV, expected_mem_CE, expected_mem_CRE, expected_mem_LB, expected_mem_OE, expected_mem_UB, expected_mem_WAIT, expected_mem_WE);
                $display("  Got:      RW=%b, mem_ADV=%b, mem_CE=%b, mem_CRE=%b, mem_LB=%b, mem_OE=%b, mem_UB=%b, mem_WAIT=%b, mem_WE=%b",
                         RW, mem_ADV, mem_CE, mem_CRE, mem_LB, mem_OE, mem_UB, mem_WAIT, mem_WE);
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
