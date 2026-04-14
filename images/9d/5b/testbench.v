`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A0;
    reg A1;
    reg A2;
    reg A3;
    wire O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A0(A0),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .O(O)
    );
    task testcase001;

        begin
            test_num = 1;
            {A3, A2, A1, A0} = 4'b0000;
            $display("Testcase %03d: Address 0000", test_num);
            #1;

            check_outputs(TB_INIT[0]);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            {A3, A2, A1, A0} = 4'b0001;
            $display("Testcase %03d: Address 0001", test_num);
            #1;

            check_outputs(TB_INIT[1]);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            {A3, A2, A1, A0} = 4'b0010;
            $display("Testcase %03d: Address 0010", test_num);
            #1;

            check_outputs(TB_INIT[2]);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            {A3, A2, A1, A0} = 4'b0011;
            $display("Testcase %03d: Address 0011", test_num);
            #1;

            check_outputs(TB_INIT[3]);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            {A3, A2, A1, A0} = 4'b0100;
            $display("Testcase %03d: Address 0100", test_num);
            #1;

            check_outputs(TB_INIT[4]);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            {A3, A2, A1, A0} = 4'b0101;
            $display("Testcase %03d: Address 0101", test_num);
            #1;

            check_outputs(TB_INIT[5]);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            {A3, A2, A1, A0} = 4'b0110;
            $display("Testcase %03d: Address 0110", test_num);
            #1;

            check_outputs(TB_INIT[6]);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            {A3, A2, A1, A0} = 4'b0111;
            $display("Testcase %03d: Address 0111", test_num);
            #1;

            check_outputs(TB_INIT[7]);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            {A3, A2, A1, A0} = 4'b1000;
            $display("Testcase %03d: Address 1000", test_num);
            #1;

            check_outputs(TB_INIT[8]);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            {A3, A2, A1, A0} = 4'b1001;
            $display("Testcase %03d: Address 1001", test_num);
            #1;

            check_outputs(TB_INIT[9]);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            {A3, A2, A1, A0} = 4'b1010;
            $display("Testcase %03d: Address 1010", test_num);
            #1;

            check_outputs(TB_INIT[10]);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            {A3, A2, A1, A0} = 4'b1011;
            $display("Testcase %03d: Address 1011", test_num);
            #1;

            check_outputs(TB_INIT[11]);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            {A3, A2, A1, A0} = 4'b1100;
            $display("Testcase %03d: Address 1100", test_num);
            #1;

            check_outputs(TB_INIT[12]);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            {A3, A2, A1, A0} = 4'b1101;
            $display("Testcase %03d: Address 1101", test_num);
            #1;

            check_outputs(TB_INIT[13]);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            {A3, A2, A1, A0} = 4'b1110;
            $display("Testcase %03d: Address 1110", test_num);
            #1;

            check_outputs(TB_INIT[14]);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            {A3, A2, A1, A0} = 4'b1111;
            $display("Testcase %03d: Address 1111", test_num);
            #1;

            check_outputs(TB_INIT[15]);
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input expected_O;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%b",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%b",
                         expected_O);
                $display("  Got:      O=%b",
                         O);
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
