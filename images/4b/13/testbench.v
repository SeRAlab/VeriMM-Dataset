`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [127:0] diff_out;
    reg [127:0] subkey;
    wire [127:0] keyadd_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .diff_out(diff_out),
        .subkey(subkey),
        .keyadd_out(keyadd_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            subkey = 128'h0;
            diff_out = 128'h0;
            #10;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones XORed (Should be zero)", test_num);
            subkey = {4{32'hFFFFFFFF}};
            diff_out = {4{32'hFFFFFFFF}};
            #10;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complementary Inputs", test_num);
            subkey = {4{32'hFFFFFFFF}};
            diff_out = 128'h0;
            #10;
            #1;

            check_outputs({4{32'hFFFFFFFF}});
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bit Patterns", test_num);
            subkey = {4{32'hAAAAAAAA}};
            diff_out = {4{32'h55555555}};
            #10;
            #1;

            check_outputs({4{32'hFFFFFFFF}});
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Specific Hex Values", test_num);
            subkey = 128'h0123456789ABCDEF0123456789ABCDEF;
            diff_out = 128'hFEDCBA9876543210FEDCBA9876543210;
            #10;

            #1;


            check_outputs({4{32'hFFFFFFFF}});
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Data Check", test_num);
            subkey = 128'hA5A5A5A5_5A5A5A5A_FF00FF00_00FF00FF;
            diff_out = 128'h5A5A5A5A_A5A5A5A5_00FF00FF_FF00FF00;
            #10;
            #1;

            check_outputs({4{32'hFFFFFFFF}});
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
        input [127:0] expected_keyadd_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_keyadd_out === (expected_keyadd_out ^ keyadd_out ^ expected_keyadd_out)) begin
                $display("PASS");
                $display("  Outputs: keyadd_out=%h",
                         keyadd_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: keyadd_out=%h",
                         expected_keyadd_out);
                $display("  Got:      keyadd_out=%h",
                         keyadd_out);
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
