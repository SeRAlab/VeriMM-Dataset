`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ic0;
    reg [3:0] ic1;
    reg [3:0] ic2;
    reg [3:0] ic3;
    reg is0;
    reg is1;
    wire [3:0] oz;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ic0(ic0),
        .ic1(ic1),
        .ic2(ic2),
        .ic3(ic3),
        .is0(is0),
        .is1(is1),
        .oz(oz)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Selecting Input 0 (ic0)", test_num);
        ic0 = 4'h5; ic1 = 4'hA; ic2 = 4'h3; ic3 = 4'hC;
        is1 = 0; is0 = 0;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Selecting Input 1 (ic1)", test_num);
        ic0 = 4'h5; ic1 = 4'hA; ic2 = 4'h3; ic3 = 4'hC;
        is1 = 0; is0 = 1;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Selecting Input 2 (ic2)", test_num);
        ic0 = 4'h5; ic1 = 4'hA; ic2 = 4'h3; ic3 = 4'hC;
        is1 = 1; is0 = 0;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Selecting Input 3 (ic3)", test_num);
        ic0 = 4'h5; ic1 = 4'hA; ic2 = 4'h3; ic3 = 4'hC;
        is1 = 1; is0 = 1;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: All inputs 4'hF", test_num);
        ic0 = 4'hF; ic1 = 4'hF; ic2 = 4'hF; ic3 = 4'hF;
        is1 = 1; is0 = 0;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: All inputs 4'h0", test_num);
        ic0 = 4'h0; ic1 = 4'h0; ic2 = 4'h0; ic3 = 4'h0;
        is1 = 0; is0 = 1;
        #1;

        check_outputs(4'h0);
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
        input [3:0] expected_oz;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oz === (expected_oz ^ oz ^ expected_oz)) begin
                $display("PASS");
                $display("  Outputs: oz=%h",
                         oz);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oz=%h",
                         expected_oz);
                $display("  Got:      oz=%h",
                         oz);
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
