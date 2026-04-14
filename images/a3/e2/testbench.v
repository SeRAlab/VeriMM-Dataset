`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg G0;
    reg G1;
    reg G2;
    wire [2:0] B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .G0(G0),
        .G1(G1),
        .G2(G2),
        .B(B)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Gray 000 -> Binary 000");
            {G2, G1, G0} = 3'b000;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Gray 001 -> Binary 001");
            {G2, G1, G0} = 3'b001;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Gray 011 -> Binary 010");
            {G2, G1, G0} = 3'b011;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Gray 010 -> Binary 011");
            {G2, G1, G0} = 3'b010;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Gray 110 -> Binary 100");
            {G2, G1, G0} = 3'b110;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Gray 111 -> Binary 101");
            {G2, G1, G0} = 3'b111;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Gray 101 -> Binary 110");
            {G2, G1, G0} = 3'b101;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Gray 100 -> Binary 111");
            {G2, G1, G0} = 3'b100;
            #1;

            check_outputs(3'b111);
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
        input [2:0] expected_B;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_B === (expected_B ^ B ^ expected_B)) begin
                $display("PASS");
                $display("  Outputs: B=%h",
                         B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B=%h",
                         expected_B);
                $display("  Got:      B=%h",
                         B);
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
