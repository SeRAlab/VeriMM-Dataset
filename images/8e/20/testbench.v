`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] in;
    wire [10:0] out_any;
    wire [10:0] out_both;
    wire [11:0] out_different;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_any(out_any),
        .out_both(out_both),
        .out_different(out_different)
    );
    task testcase001;

    begin
        test_num = 1;
        in = 12'h000;
        #1;

        check_outputs(11'h000, 11'h000, 12'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in = 12'hFFF;
        #1;

        check_outputs(11'h7FF, 11'h7FF, 12'h000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in = 12'hAAA;
        #1;

        check_outputs(11'h7FF, 11'h000, 12'hFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in = 12'h555;
        #1;

        check_outputs(11'h7FF, 11'h000, 12'hFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in = 12'hCCC;
        #1;

        check_outputs(11'h6EE, 11'h444, 12'hAAA);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in = 12'h801;
        #1;

        check_outputs(11'h401, 11'h000, 12'h401);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in = 12'h123;
        #1;

        check_outputs(11'h1B3, 11'h001, 12'h962);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in = 12'hFED;
        #1;

        check_outputs(11'h7FF, 11'h7E4, 12'h01B);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        in = 12'h001;
        #1;

        check_outputs(11'h001, 11'h000, 12'h801);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        in = 12'h800;
        #1;

        check_outputs(11'h400, 11'h000, 12'hC00);
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
        input [10:0] expected_out_any;
        input [10:0] expected_out_both;
        input [11:0] expected_out_different;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_any === (expected_out_any ^ out_any ^ expected_out_any) &&
                expected_out_both === (expected_out_both ^ out_both ^ expected_out_both) &&
                expected_out_different === (expected_out_different ^ out_different ^ expected_out_different)) begin
                $display("PASS");
                $display("  Outputs: out_any=%h, out_both=%h, out_different=%h",
                         out_any, out_both, out_different);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_any=%h, out_both=%h, out_different=%h",
                         expected_out_any, expected_out_both, expected_out_different);
                $display("  Got:      out_any=%h, out_both=%h, out_different=%h",
                         out_any, out_both, out_different);
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
