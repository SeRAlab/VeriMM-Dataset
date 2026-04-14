`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg D;
    reg nCLK;
    reg nSET;
    wire nQ;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .nCLK(nCLK),
        .nSET(nSET),
        .nQ(nQ)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Force nSET low", test_num);

            nSET = 0;
            D = 1;
            nCLK = 1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transparent mode (nCLK=0, D=0)", test_num);

            nSET = 0; #10;
            nSET = 1;
            nCLK = 0;
            D = 0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transparent mode (nCLK=0, D=1)", test_num);

            nSET = 0; #10;
            nSET = 1;
            nCLK = 0;
            D = 1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Hold mode (nCLK transition to 1)", test_num);

            nSET = 0; #10;
            nSET = 1;

            nCLK = 0;
            D = 0;
            #10;
            nCLK = 1;
            #10;
            D = 1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: nSET priority over transparent clock", test_num);

            nSET = 0; #10;
            nSET = 1;

            nCLK = 0;
            D = 0;
            #10;
            nSET = 0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition on falling edge of nCLK", test_num);

            nSET = 0; #10;
            nSET = 1;
            nCLK = 1;
            D = 1;
            #10;
            nCLK = 0;
            D = 0;
            #10;
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
        input expected_nQ;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_nQ === (expected_nQ ^ nQ ^ expected_nQ)) begin
                $display("PASS");
                $display("  Outputs: nQ=%b",
                         nQ);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nQ=%b",
                         expected_nQ);
                $display("  Got:      nQ=%b",
                         nQ);
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
