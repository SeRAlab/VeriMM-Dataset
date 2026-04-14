`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in0;
    reg in1;
    reg in2;
    reg in3;
    reg sel0;
    reg sel1;
    reg sel2;
    reg sel3;
    wire dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .sel0(sel0),
        .sel1(sel1),
        .sel2(sel2),
        .sel3(sel3),
        .dout(dout)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Select in0 (value 1)", test_num);
            in0 = 1; in1 = 0; in2 = 0; in3 = 0;
            sel0 = 1; sel1 = 0; sel2 = 0; sel3 = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Select in1 (value 1)", test_num);
            in0 = 0; in1 = 1; in2 = 0; in3 = 0;
            sel0 = 0; sel1 = 1; sel2 = 0; sel3 = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Select in2 (value 1)", test_num);
            in0 = 0; in1 = 0; in2 = 1; in3 = 0;
            sel0 = 0; sel1 = 0; sel2 = 1; sel3 = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Select in3 (value 1)", test_num);
            in0 = 0; in1 = 0; in2 = 0; in3 = 1;
            sel0 = 0; sel1 = 0; sel2 = 0; sel3 = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: No select active", test_num);
            in0 = 1; in1 = 1; in2 = 1; in3 = 1;
            sel0 = 0; sel1 = 0; sel2 = 0; sel3 = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Select in0 (value 0)", test_num);
            in0 = 0; in1 = 1; in2 = 1; in3 = 1;
            sel0 = 1; sel1 = 0; sel2 = 0; sel3 = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Select in1 (value 0)", test_num);
            in0 = 1; in1 = 0; in2 = 1; in3 = 1;
            sel0 = 0; sel1 = 1; sel2 = 0; sel3 = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Select in2 (value 0)", test_num);
            in0 = 1; in1 = 1; in2 = 0; in3 = 1;
            sel0 = 0; sel1 = 0; sel2 = 1; sel3 = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %03d: Select in3 (value 0)", test_num);
            in0 = 1; in1 = 1; in2 = 1; in3 = 0;
            sel0 = 0; sel1 = 0; sel2 = 0; sel3 = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %03d: All inputs 1, Select in1", test_num);
            in0 = 1; in1 = 1; in2 = 1; in3 = 1;
            sel0 = 0; sel1 = 1; sel2 = 0; sel3 = 0;
            #1;

            check_outputs(1);
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
        input expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%b",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%b",
                         expected_dout);
                $display("  Got:      dout=%b",
                         dout);
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
