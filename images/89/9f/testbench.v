`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg pa;
    reg pb;
    reg pc;
    reg pd;
    reg pe;
    wire pf;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pa(pa),
        .pb(pb),
        .pc(pc),
        .pd(pd),
        .pe(pe),
        .pf(pf)
    );
    task testcase001;

    begin
        test_num = 1;
        {pa, pb, pc, pd, pe} = 5'b00000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        {pa, pb, pc, pd, pe} = 5'b11000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        {pa, pb, pc, pd, pe} = 5'b00111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        {pa, pb, pc, pd, pe} = 5'b11111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        {pa, pb, pc, pd, pe} = 5'b10111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        {pa, pb, pc, pd, pe} = 5'b11110;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        {pa, pb, pc, pd, pe} = 5'b10110;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        {pa, pb, pc, pd, pe} = 5'b00101;
        #1;

        check_outputs(1'b1);
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
        input expected_pf;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pf === (expected_pf ^ pf ^ expected_pf)) begin
                $display("PASS");
                $display("  Outputs: pf=%b",
                         pf);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pf=%b",
                         expected_pf);
                $display("  Got:      pf=%b",
                         pf);
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
