`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in_VGND;
    reg in_VNB;
    reg in_VPB;
    reg in_VPWR;
    wire out_VGND;
    wire out_VNB;
    wire out_VPB;
    wire out_VPWR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_VGND(in_VGND),
        .in_VNB(in_VNB),
        .in_VPB(in_VPB),
        .in_VPWR(in_VPWR),
        .out_VGND(out_VGND),
        .out_VNB(out_VNB),
        .out_VPB(out_VPB),
        .out_VPWR(out_VPWR)
    );
    task testcase001;

        begin
            test_num = 1;
            in_VGND = 0; in_VNB = 0; in_VPB = 0; in_VPWR = 0;
            $display("Test %0d: All inputs Low", test_num);
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in_VGND = 1; in_VNB = 1; in_VPB = 1; in_VPWR = 1;
            $display("Test %0d: All inputs High", test_num);
            #1;

            check_outputs(1, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in_VGND = 0; in_VNB = 1; in_VPB = 0; in_VPWR = 1;
            $display("Test %0d: Alternating inputs (0101)", test_num);
            #1;

            check_outputs(0, 1, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in_VGND = 1; in_VNB = 0; in_VPB = 1; in_VPWR = 0;
            $display("Test %0d: Alternating inputs (1010)", test_num);
            #1;

            check_outputs(1, 0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in_VGND = 0; in_VNB = 0; in_VPB = 0; in_VPWR = 1;
            $display("Test %0d: Only in_VPWR High", test_num);
            #1;

            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in_VGND = 1; in_VNB = 0; in_VPB = 0; in_VPWR = 0;
            $display("Test %0d: Only in_VGND High", test_num);
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in_VGND = 0; in_VNB = 0; in_VPB = 1; in_VPWR = 0;
            $display("Test %0d: Only in_VPB High", test_num);
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in_VGND = 0; in_VNB = 1; in_VPB = 0; in_VPWR = 0;
            $display("Test %0d: Only in_VNB High", test_num);
            #1;

            check_outputs(0, 1, 0, 0);
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
        input expected_out_VGND;
        input expected_out_VNB;
        input expected_out_VPB;
        input expected_out_VPWR;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_VGND === (expected_out_VGND ^ out_VGND ^ expected_out_VGND) &&
                expected_out_VNB === (expected_out_VNB ^ out_VNB ^ expected_out_VNB) &&
                expected_out_VPB === (expected_out_VPB ^ out_VPB ^ expected_out_VPB) &&
                expected_out_VPWR === (expected_out_VPWR ^ out_VPWR ^ expected_out_VPWR)) begin
                $display("PASS");
                $display("  Outputs: out_VGND=%b, out_VNB=%b, out_VPB=%b, out_VPWR=%b",
                         out_VGND, out_VNB, out_VPB, out_VPWR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_VGND=%b, out_VNB=%b, out_VPB=%b, out_VPWR=%b",
                         expected_out_VGND, expected_out_VNB, expected_out_VPB, expected_out_VPWR);
                $display("  Got:      out_VGND=%b, out_VNB=%b, out_VPB=%b, out_VPWR=%b",
                         out_VGND, out_VNB, out_VPB, out_VPWR);
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
