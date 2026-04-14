`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    wire out_pos;
    wire out_sop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .out_pos(out_pos),
        .out_sop(out_sop)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 0; b = 0; c = 0;
        $display("Test Case %0d: Input abc=000", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 0; b = 0; c = 1;
        $display("Test Case %0d: Input abc=001", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 0; b = 1; c = 0;
        $display("Test Case %0d: Input abc=010", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 0; b = 1; c = 1;
        $display("Test Case %0d: Input abc=011", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 1; b = 0; c = 0;
        $display("Test Case %0d: Input abc=100", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 1; b = 0; c = 1;
        $display("Test Case %0d: Input abc=101", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 1; b = 1; c = 0;
        $display("Test Case %0d: Input abc=110", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 1; b = 1; c = 1;
        $display("Test Case %0d: Input abc=111", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
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
        input expected_out_pos;
        input expected_out_sop;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_pos === (expected_out_pos ^ out_pos ^ expected_out_pos) &&
                expected_out_sop === (expected_out_sop ^ out_sop ^ expected_out_sop)) begin
                $display("PASS");
                $display("  Outputs: out_pos=%b, out_sop=%b",
                         out_pos, out_sop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_pos=%b, out_sop=%b",
                         expected_out_pos, expected_out_sop);
                $display("  Got:      out_pos=%b, out_sop=%b",
                         out_pos, out_sop);
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
