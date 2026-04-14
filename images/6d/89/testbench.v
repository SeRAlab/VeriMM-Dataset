`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] arg_0;
    reg clk;
    reg rst_n;
    wire [31:0] ret_0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .arg_0(arg_0),
        .clk(clk),
        .rst_n(rst_n),
        .ret_0(ret_0)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Verification", test_num);

            rst_n = 0;
            arg_0 = 32'hFFFF_FFFF;
            clk = 0; #5; clk = 1; #5; clk = 0;

            #1;


            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Data Transfer (0x12345678)", test_num);

            rst_n = 0; clk = 0; #5; clk = 1; #5; clk = 0;

            rst_n = 1;
            arg_0 = 32'h1234_5678;
            #5; clk = 1; #5; clk = 0;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bit Pattern (0xAAAAAAAA)", test_num);

            rst_n = 0; clk = 0; #5; clk = 1; #5; clk = 0;

            rst_n = 1;
            arg_0 = 32'hAAAA_AAAA;
            #5; clk = 1; #5; clk = 0;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Value - All Ones", test_num);

            rst_n = 0; clk = 0; #5; clk = 1; #5; clk = 0;

            rst_n = 1;
            arg_0 = 32'hFFFF_FFFF;
            #5; clk = 1; #5; clk = 0;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Value - All Zeros Post-Reset", test_num);

            rst_n = 0; clk = 0; #5; clk = 1; #5; clk = 0;

            rst_n = 1;
            arg_0 = 32'h0000_0000;
            #5; clk = 1; #5; clk = 0;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random Hex Pattern (0xDEADBEEF)", test_num);

            rst_n = 0; clk = 0; #5; clk = 1; #5; clk = 0;

            rst_n = 1;
            arg_0 = 32'hDEAD_BEEF;
            #5; clk = 1; #5; clk = 0;
            #1;

            check_outputs(32'hDEAD_BEEF);
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
        input [31:0] expected_ret_0;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ret_0 === (expected_ret_0 ^ ret_0 ^ expected_ret_0)) begin
                $display("PASS");
                $display("  Outputs: ret_0=%h",
                         ret_0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ret_0=%h",
                         expected_ret_0);
                $display("  Got:      ret_0=%h",
                         ret_0);
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
