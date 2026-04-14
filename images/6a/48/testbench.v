`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] in;
    wire [10:0] out_and;
    wire [10:0] out_or;
    wire [11:0] out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_and(out_and),
        .out_or(out_or),
        .out_xor(out_xor)
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

        check_outputs(11'h000, 11'h7FF, 12'hFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in = 12'h555;
        #1;

        check_outputs(11'h000, 11'h7FF, 12'hFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in = 12'hCCC;
        #1;

        check_outputs(11'h444, 11'h6EE, 12'h555);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in = 12'h001;
        #1;

        check_outputs(11'h000, 11'h001, 12'h003);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in = 12'h800;
        #1;

        check_outputs(11'h000, 11'h400, 12'h801);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in = 12'h801;
        #1;

        check_outputs(11'h000, 11'h401, 12'h802);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        in = 12'hF0F;
        #1;

        check_outputs(11'h707, 11'h78F, 12'h088);
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
        input [10:0] expected_out_and;
        input [10:0] expected_out_or;
        input [11:0] expected_out_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_or === (expected_out_or ^ out_or ^ expected_out_or) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: out_and=%h, out_or=%h, out_xor=%h",
                         out_and, out_or, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and=%h, out_or=%h, out_xor=%h",
                         expected_out_and, expected_out_or, expected_out_xor);
                $display("  Got:      out_and=%h, out_or=%h, out_xor=%h",
                         out_and, out_or, out_xor);
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
