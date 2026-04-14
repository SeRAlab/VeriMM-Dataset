`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [29:0] i_addr;
    wire o_cachable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_addr(i_addr),
        .o_cachable(o_cachable)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        i_addr = 30'h0000_0000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        i_addr = 30'h0AAA_AAAA;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        i_addr = 30'h0FFF_FFFF;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        i_addr = 30'h1000_0000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        i_addr = 30'h1ABC_DEF0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        i_addr = 30'h2000_0000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        i_addr = 30'h2555_5555;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        i_addr = 30'h3FFF_FFFF;
        #1;

        check_outputs(1'b0);
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
        input expected_o_cachable;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_cachable === (expected_o_cachable ^ o_cachable ^ expected_o_cachable)) begin
                $display("PASS");
                $display("  Outputs: o_cachable=%b",
                         o_cachable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_cachable=%b",
                         expected_o_cachable);
                $display("  Got:      o_cachable=%b",
                         o_cachable);
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
