`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg sys_clk;
    reg sys_rst;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sys_clk(sys_clk),
        .sys_rst(sys_rst)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\n[Testcase %0d] Power-on Reset and Initialization", test_num);

            sys_rst = 1;
            repeat(5) @(posedge sys_clk);
            sys_rst = 0;


            @(posedge sys_clk);

            #1;


            check_outputs();
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\n[Testcase %0d] Warm Reset Stability Check", test_num);

            sys_rst = 0;
            repeat(2) @(posedge sys_clk);
            sys_rst = 1;
            repeat(2) @(posedge sys_clk);
            sys_rst = 0;

            repeat(5) @(posedge sys_clk);

            #1;


            check_outputs();
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\n[Testcase %0d] Extended Run Verification", test_num);

            sys_rst = 1;
            #10;
            sys_rst = 0;

            repeat(50) @(posedge sys_clk);

            #1;


            check_outputs();
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
        begin
            #1; // Small delay for combinational logic to settle
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
