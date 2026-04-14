`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in0;
    reg in1;
    reg in2;
    reg in3;
    reg sel0;
    reg sel1;
    wire out;

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
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        in0 = 1'b0; in1 = 1'b1; in2 = 1'b1; in3 = 1'b1;
        sel1 = 1'b0; sel0 = 1'b0;
        $display("Test %0d: sel=00 (in0), in0=0, others=1", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in0 = 1'b1; in1 = 1'b0; in2 = 1'b0; in3 = 1'b0;
        sel1 = 1'b0; sel0 = 1'b0;
        $display("Test %0d: sel=00 (in0), in0=1, others=0", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in0 = 1'b1; in1 = 1'b0; in2 = 1'b1; in3 = 1'b1;
        sel1 = 1'b0; sel0 = 1'b1;
        $display("Test %0d: sel=01 (in1), in1=0, others=1", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in0 = 1'b0; in1 = 1'b1; in2 = 1'b0; in3 = 1'b0;
        sel1 = 1'b0; sel0 = 1'b1;
        $display("Test %0d: sel=01 (in1), in1=1, others=0", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in0 = 1'b1; in1 = 1'b1; in2 = 1'b0; in3 = 1'b1;
        sel1 = 1'b1; sel0 = 1'b0;
        $display("Test %0d: sel=10 (in2), in2=0, others=1", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in0 = 1'b0; in1 = 1'b0; in2 = 1'b1; in3 = 1'b0;
        sel1 = 1'b1; sel0 = 1'b0;
        $display("Test %0d: sel=10 (in2), in2=1, others=0", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in0 = 1'b1; in1 = 1'b1; in2 = 1'b1; in3 = 1'b0;
        sel1 = 1'b1; sel0 = 1'b1;
        $display("Test %0d: sel=11 (in3), in3=0, others=1", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in0 = 1'b0; in1 = 1'b0; in2 = 1'b0; in3 = 1'b1;
        sel1 = 1'b1; sel0 = 1'b1;
        $display("Test %0d: sel=11 (in3), in3=1, others=0", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;

        in0 = 1'b0; in1 = 1'b1; in2 = 1'b0; in3 = 1'b0;
        sel1 = 1'b0; sel0 = 1'b1;
        #5;

        in0 = 1'b1; in2 = 1'b1; in3 = 1'b1;
        $display("Test %0d: sel=01 (in1), changing unselected inputs", test_num);
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
        testcase009();
        
        
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
