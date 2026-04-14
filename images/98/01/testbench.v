`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in_vec;
    reg sel_comp;
    wire [3:0] complement;
    wire [3:0] outv;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_vec(in_vec),
        .sel_comp(sel_comp),
        .complement(complement),
        .outv(outv)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: One's complement of 0000", test_num);
        in_vec = 4'b0000;
        sel_comp = 0;
        #1;

        check_outputs(4'b1111, 4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: One's complement of 1111", test_num);
        in_vec = 4'b1111;
        sel_comp = 0;
        #1;

        check_outputs(4'b0000, 4'b1111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: One's complement of 1010", test_num);
        in_vec = 4'b1010;
        sel_comp = 0;
        #1;

        check_outputs(4'b0101, 4'b1010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Two's complement of 0000", test_num);
        in_vec = 4'b0000;
        sel_comp = 1;
        #1;

        check_outputs(4'b0000, 4'b0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Two's complement of 0001", test_num);
        in_vec = 4'b0001;
        sel_comp = 1;
        #1;

        check_outputs(4'b1111, 4'b0001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Two's complement of 1000 (edge case)", test_num);
        in_vec = 4'b1000;
        sel_comp = 1;
        #1;

        check_outputs(4'b1000, 4'b1000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Two's complement of 1111", test_num);
        in_vec = 4'b1111;
        sel_comp = 1;
        #1;

        check_outputs(4'b0001, 4'b1111);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Two's complement of 0101", test_num);
        in_vec = 4'b0101;
        sel_comp = 1;
        #1;

        check_outputs(4'b1011, 4'b0101);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: One's complement of 0110", test_num);
        in_vec = 4'b0110;
        sel_comp = 0;
        #1;

        check_outputs(4'b1001, 4'b0110);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Check outv for 1100", test_num);
        in_vec = 4'b1100;
        sel_comp = 0;
        #1;

        check_outputs(4'b0011, 4'b1100);
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
        input [3:0] expected_complement;
        input [3:0] expected_outv;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_complement === (expected_complement ^ complement ^ expected_complement) &&
                expected_outv === (expected_outv ^ outv ^ expected_outv)) begin
                $display("PASS");
                $display("  Outputs: complement=%h, outv=%h",
                         complement, outv);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: complement=%h, outv=%h",
                         expected_complement, expected_outv);
                $display("  Got:      complement=%h, outv=%h",
                         complement, outv);
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
