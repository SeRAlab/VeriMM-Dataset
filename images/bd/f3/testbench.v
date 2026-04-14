`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg pi0;
    reg pi1;
    reg pi2;
    reg pi3;
    reg pi4;
    wire po0;
    wire po1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pi0(pi0),
        .pi1(pi1),
        .pi2(pi2),
        .pi3(pi3),
        .pi4(pi4),
        .po0(po0),
        .po1(po1)
    );
    task testcase001;

    begin
        test_num = 1;
        {pi4, pi3, pi2, pi1, pi0} = 5'b00000;

        #1;


        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        {pi4, pi3, pi2, pi1, pi0} = 5'b11111;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        {pi4, pi3, pi2, pi1, pi0} = 5'b10101;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        {pi4, pi3, pi2, pi1, pi0} = 5'b01010;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        {pi4, pi3, pi2, pi1, pi0} = 5'b10000;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        {pi4, pi3, pi2, pi1, pi0} = 5'b00001;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        {pi4, pi3, pi2, pi1, pi0} = 5'b00111;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        {pi4, pi3, pi2, pi1, pi0} = 5'b11100;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        {pi4, pi3, pi2, pi1, pi0} = 5'b11011;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        {pi4, pi3, pi2, pi1, pi0} = 5'b01111;
        #1;

        check_outputs(1'b1, 1'b0);
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
        testcase009();
        testcase010();
        
        
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
        input expected_po0;
        input expected_po1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_po0 === (expected_po0 ^ po0 ^ expected_po0) &&
                expected_po1 === (expected_po1 ^ po1 ^ expected_po1)) begin
                $display("PASS");
                $display("  Outputs: po0=%b, po1=%b",
                         po0, po1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: po0=%b, po1=%b",
                         expected_po0, expected_po1);
                $display("  Got:      po0=%b, po1=%b",
                         po0, po1);
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
