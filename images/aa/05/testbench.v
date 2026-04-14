`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg colSelA;
    reg colSelB;
    reg colSelC;
    reg datai;
    wire datao;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .colSelA(colSelA),
        .colSelB(colSelB),
        .colSelC(colSelC),
        .datai(datai),
        .datao(datao)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs zero", test_num);
            colSelA = 1'b0; colSelB = 1'b0; colSelC = 1'b0; datai = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Set datai only", test_num);
            colSelA = 1'b0; colSelB = 1'b0; colSelC = 1'b0; datai = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Set colSelC only", test_num);
            colSelA = 1'b0; colSelB = 1'b0; colSelC = 1'b1; datai = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Set colSelB and datai", test_num);
            colSelA = 1'b0; colSelB = 1'b1; colSelC = 1'b0; datai = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Set colSelA only", test_num);
            colSelA = 1'b1; colSelB = 1'b0; colSelC = 1'b0; datai = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All colSel high, datai low", test_num);
            colSelA = 1'b1; colSelB = 1'b1; colSelC = 1'b1; datai = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs high", test_num);
            colSelA = 1'b1; colSelB = 1'b1; colSelC = 1'b1; datai = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bit pattern", test_num);
            colSelA = 1'b1; colSelB = 1'b0; colSelC = 1'b1; datai = 1'b0;
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
        input expected_datao;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_datao === (expected_datao ^ datao ^ expected_datao)) begin
                $display("PASS");
                $display("  Outputs: datao=%b",
                         datao);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: datao=%b",
                         expected_datao);
                $display("  Got:      datao=%b",
                         datao);
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
