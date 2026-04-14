`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in;
    reg sel0;
    reg sel1;
    reg sel2;
    wire out0;
    wire out1;
    wire out2;
    wire out3;
    wire out4;
    wire out5;
    wire out6;
    wire out7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .sel0(sel0),
        .sel1(sel1),
        .sel2(sel2),
        .out0(out0),
        .out1(out1),
        .out2(out2),
        .out3(out3),
        .out4(out4),
        .out5(out5),
        .out6(out6),
        .out7(out7)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: sel=000, in=1", test_num);
        sel2 = 0; sel1 = 0; sel0 = 0; in = 1;
        #1;

        check_outputs(1, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: sel=001, in=1", test_num);
        sel2 = 0; sel1 = 0; sel0 = 1; in = 1;
        #1;

        check_outputs(0, 1, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: sel=010, in=1", test_num);
        sel2 = 0; sel1 = 1; sel0 = 0; in = 1;
        #1;

        check_outputs(0, 0, 1, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: sel=011, in=1", test_num);
        sel2 = 0; sel1 = 1; sel0 = 1; in = 1;
        #1;

        check_outputs(0, 0, 0, 1, 0, 0, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: sel=100, in=1", test_num);
        sel2 = 1; sel1 = 0; sel0 = 0; in = 1;
        #1;

        check_outputs(0, 0, 0, 0, 1, 0, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: sel=101, in=1", test_num);
        sel2 = 1; sel1 = 0; sel0 = 1; in = 1;
        #1;

        check_outputs(0, 0, 0, 0, 0, 1, 0, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: sel=110, in=1", test_num);
        sel2 = 1; sel1 = 1; sel0 = 0; in = 1;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 1, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: sel=111, in=1", test_num);
        sel2 = 1; sel1 = 1; sel0 = 1; in = 1;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 0, 1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: sel=000, in=0", test_num);
        sel2 = 0; sel1 = 0; sel0 = 0; in = 0;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: sel=111, in=0", test_num);
        sel2 = 1; sel1 = 1; sel0 = 1; in = 0;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 0, 0);
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
        input expected_out0;
        input expected_out1;
        input expected_out2;
        input expected_out3;
        input expected_out4;
        input expected_out5;
        input expected_out6;
        input expected_out7;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out0 === (expected_out0 ^ out0 ^ expected_out0) &&
                expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2) &&
                expected_out3 === (expected_out3 ^ out3 ^ expected_out3) &&
                expected_out4 === (expected_out4 ^ out4 ^ expected_out4) &&
                expected_out5 === (expected_out5 ^ out5 ^ expected_out5) &&
                expected_out6 === (expected_out6 ^ out6 ^ expected_out6) &&
                expected_out7 === (expected_out7 ^ out7 ^ expected_out7)) begin
                $display("PASS");
                $display("  Outputs: out0=%b, out1=%b, out2=%b, out3=%b, out4=%b, out5=%b, out6=%b, out7=%b",
                         out0, out1, out2, out3, out4, out5, out6, out7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out0=%b, out1=%b, out2=%b, out3=%b, out4=%b, out5=%b, out6=%b, out7=%b",
                         expected_out0, expected_out1, expected_out2, expected_out3, expected_out4, expected_out5, expected_out6, expected_out7);
                $display("  Got:      out0=%b, out1=%b, out2=%b, out3=%b, out4=%b, out5=%b, out6=%b, out7=%b",
                         out0, out1, out2, out3, out4, out5, out6, out7);
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
