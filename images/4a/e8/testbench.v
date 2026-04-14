`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in0;
    reg in1;
    reg in2;
    reg in3;
    reg in4;
    reg in5;
    reg in6;
    reg in7;
    reg sel0_l;
    reg sel1_l;
    reg sel2_l;
    reg sel3_l;
    reg sel4_l;
    reg sel5_l;
    reg sel6_l;
    reg sel7_l;
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
        .in4(in4),
        .in5(in5),
        .in6(in6),
        .in7(in7),
        .sel0_l(sel0_l),
        .sel1_l(sel1_l),
        .sel2_l(sel2_l),
        .sel3_l(sel3_l),
        .sel4_l(sel4_l),
        .sel5_l(sel5_l),
        .sel6_l(sel6_l),
        .sel7_l(sel7_l),
        .dout(dout)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Select in0, value 1", test_num);

            {sel0_l, sel1_l, sel2_l, sel3_l, sel4_l, sel5_l, sel6_l, sel7_l} = 8'b1111_1111;
            sel0_l = 1'b0;
            in0 = 1'b1; in1 = 1'b0; in2 = 1'b0; in3 = 1'b0;
            in4 = 1'b0; in5 = 1'b0; in6 = 1'b0; in7 = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Select in1, value 1", test_num);
            {sel0_l, sel1_l, sel2_l, sel3_l, sel4_l, sel5_l, sel6_l, sel7_l} = 8'b1111_1111;
            sel1_l = 1'b0;
            in0 = 1'b0; in1 = 1'b1; in2 = 1'b0; in3 = 1'b0;
            in4 = 1'b0; in5 = 1'b0; in6 = 1'b0; in7 = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Select in2, value 1", test_num);
            {sel0_l, sel1_l, sel2_l, sel3_l, sel4_l, sel5_l, sel6_l, sel7_l} = 8'b1111_1111;
            sel2_l = 1'b0;
            in0 = 1'b0; in1 = 1'b0; in2 = 1'b1; in3 = 1'b0;
            in4 = 1'b0; in5 = 1'b0; in6 = 1'b0; in7 = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Select in3, value 1", test_num);
            {sel0_l, sel1_l, sel2_l, sel3_l, sel4_l, sel5_l, sel6_l, sel7_l} = 8'b1111_1111;
            sel3_l = 1'b0;
            in0 = 1'b0; in1 = 1'b0; in2 = 1'b0; in3 = 1'b1;
            in4 = 1'b0; in5 = 1'b0; in6 = 1'b0; in7 = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Select in4, value 0", test_num);
            {sel0_l, sel1_l, sel2_l, sel3_l, sel4_l, sel5_l, sel6_l, sel7_l} = 8'b1111_1111;
            sel4_l = 1'b0;
            in0 = 1'b1; in1 = 1'b1; in2 = 1'b1; in3 = 1'b1;
            in4 = 1'b0; in5 = 1'b1; in6 = 1'b1; in7 = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Select in5, value 0", test_num);
            {sel0_l, sel1_l, sel2_l, sel3_l, sel4_l, sel5_l, sel6_l, sel7_l} = 8'b1111_1111;
            sel5_l = 1'b0;
            in0 = 1'b1; in1 = 1'b1; in2 = 1'b1; in3 = 1'b1;
            in4 = 1'b1; in5 = 1'b0; in6 = 1'b1; in7 = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Select in6, value 0", test_num);
            {sel0_l, sel1_l, sel2_l, sel3_l, sel4_l, sel5_l, sel6_l, sel7_l} = 8'b1111_1111;
            sel6_l = 1'b0;
            in0 = 1'b1; in1 = 1'b1; in2 = 1'b1; in3 = 1'b1;
            in4 = 1'b1; in5 = 1'b1; in6 = 1'b0; in7 = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Select in7, value 0", test_num);
            {sel0_l, sel1_l, sel2_l, sel3_l, sel4_l, sel5_l, sel6_l, sel7_l} = 8'b1111_1111;
            sel7_l = 1'b0;
            in0 = 1'b1; in1 = 1'b1; in2 = 1'b1; in3 = 1'b1;
            in4 = 1'b1; in5 = 1'b1; in6 = 1'b1; in7 = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Verify in0 sensitivity (Low)", test_num);
            {sel0_l, sel1_l, sel2_l, sel3_l, sel4_l, sel5_l, sel6_l, sel7_l} = 8'b1111_1111;
            sel0_l = 1'b0;
            in0 = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Verify in7 sensitivity (High)", test_num);
            {sel0_l, sel1_l, sel2_l, sel3_l, sel4_l, sel5_l, sel6_l, sel7_l} = 8'b1111_1111;
            sel7_l = 1'b0;
            in7 = 1'b1;
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
