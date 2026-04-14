`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] index;
    wire [9:0] outq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .index(index),
        .outq(outq)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Testing index 0", test_num);
        index = 8'd0;
        #1;

        check_outputs(10'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Testing index 1", test_num);
        index = 8'd1;
        #1;

        check_outputs(10'h022);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Testing index 2", test_num);
        index = 8'd2;
        #1;

        check_outputs(10'h044);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Testing index 3", test_num);
        index = 8'd3;
        #1;

        check_outputs(10'h066);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Testing index 9 (Last defined index)", test_num);
        index = 8'd9;
        #1;

        check_outputs(10'h132);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Testing index 255 (Undefined - should remain 306)", test_num);
        index = 8'hFF;


        #1;



        check_outputs(10'h132);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Returning to index 4", test_num);
        index = 8'd4;
        #1;

        check_outputs(10'h088);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Testing undefined index 15 (Should remain 136)", test_num);
        index = 8'd15;
        #1;

        check_outputs(10'h088);
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
        input [9:0] expected_outq;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outq === (expected_outq ^ outq ^ expected_outq)) begin
                $display("PASS");
                $display("  Outputs: outq=%h",
                         outq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outq=%h",
                         expected_outq);
                $display("  Got:      outq=%h",
                         outq);
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
