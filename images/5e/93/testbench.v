`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    wire f;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .f(f)
    );
    task start_test;

        input [2:0] val;
        begin
            {a, b, c} = val;
            test_num = test_num + 1;
            $display("Test Case %0d: Inputs {a,b,c} = %b", test_num, val);
        end
        endtask

    task testcase001;

    begin
        start_test(3'b000);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        start_test(3'b001);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        start_test(3'b010);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        start_test(3'b011);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        start_test(3'b100);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        start_test(3'b101);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        start_test(3'b110);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        start_test(3'b111);
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
        input expected_f;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_f === (expected_f ^ f ^ expected_f)) begin
                $display("PASS");
                $display("  Outputs: f=%b",
                         f);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f=%b",
                         expected_f);
                $display("  Got:      f=%b",
                         f);
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
