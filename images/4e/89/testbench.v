`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg I_in1;
    reg I_in2;
    reg I_sel;
    wire O_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I_in1(I_in1),
        .I_in2(I_in2),
        .I_sel(I_sel),
        .O_out(O_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: Select I_in2 (Low), Value 0", test_num);
        I_sel = 1'b0; I_in1 = 1'b1; I_in2 = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: Select I_in2 (Low), Value 1", test_num);
        I_sel = 1'b0; I_in1 = 1'b0; I_in2 = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: Select I_in1 (High), Value 0", test_num);
        I_sel = 1'b1; I_in1 = 1'b0; I_in2 = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: Select I_in1 (High), Value 1", test_num);
        I_sel = 1'b1; I_in1 = 1'b1; I_in2 = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: verify I_in1 isolation when I_sel=0", test_num);
        I_sel = 1'b0; I_in2 = 1'b1; I_in1 = 1'b0;
        #5;
        I_in1 = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %0d: verify I_in2 isolation when I_sel=1", test_num);
        I_sel = 1'b1; I_in1 = 1'b0; I_in2 = 1'b0;
        #5;
        I_in2 = 1'b1;
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
        input expected_O_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O_out === (expected_O_out ^ O_out ^ expected_O_out)) begin
                $display("PASS");
                $display("  Outputs: O_out=%b",
                         O_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O_out=%b",
                         expected_O_out);
                $display("  Got:      O_out=%b",
                         O_out);
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
