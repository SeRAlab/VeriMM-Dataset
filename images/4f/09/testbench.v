`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg c;
    reg i;
    reg k;
    reg y;
    wire j;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c(c),
        .i(i),
        .k(k),
        .y(y),
        .j(j)
    );
    task testcase001;

        begin
            test_num = 1;
            k = 0; c = 0; i = 0; y = 0;
            $display("Testcase %0d: kciy=0000", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            k = 0; c = 0; i = 0; y = 1;
            $display("Testcase %0d: kciy=0001", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            k = 0; c = 0; i = 1; y = 0;
            $display("Testcase %0d: kciy=0010", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            k = 0; c = 0; i = 1; y = 1;
            $display("Testcase %0d: kciy=0011", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            k = 0; c = 1; i = 0; y = 0;
            $display("Testcase %0d: kciy=0100", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            k = 0; c = 1; i = 0; y = 1;
            $display("Testcase %0d: kciy=0101", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            k = 0; c = 1; i = 1; y = 0;
            $display("Testcase %0d: kciy=0110", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            k = 0; c = 1; i = 1; y = 1;
            $display("Testcase %0d: kciy=0111", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            k = 1; c = 0; i = 0; y = 0;
            $display("Testcase %0d: kciy=1000", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            k = 1; c = 0; i = 0; y = 1;
            $display("Testcase %0d: kciy=1001", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            k = 1; c = 0; i = 1; y = 0;
            $display("Testcase %0d: kciy=1010", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            k = 1; c = 0; i = 1; y = 1;
            $display("Testcase %0d: kciy=1011", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            k = 1; c = 1; i = 0; y = 0;
            $display("Testcase %0d: kciy=1100", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            k = 1; c = 1; i = 0; y = 1;
            $display("Testcase %0d: kciy=1101", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            k = 1; c = 1; i = 1; y = 0;
            $display("Testcase %0d: kciy=1110", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            k = 1; c = 1; i = 1; y = 1;
            $display("Testcase %0d: kciy=1111", test_num);
            #1;

            check_outputs(1'b0);
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
        input expected_j;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_j === (expected_j ^ j ^ expected_j)) begin
                $display("PASS");
                $display("  Outputs: j=%b",
                         j);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: j=%b",
                         expected_j);
                $display("  Got:      j=%b",
                         j);
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
