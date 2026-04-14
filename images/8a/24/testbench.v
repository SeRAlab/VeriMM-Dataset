`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg d0;
    reg d1;
    reg d2;
    reg d3;
    reg sel1;
    reg sel2;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .sel1(sel1),
        .sel2(sel2),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %03d: sel1=0, sel2=0 (select d0), d0=0", test_num);
        sel1 = 0; sel2 = 0;
        d0 = 0; d1 = 1; d2 = 1; d3 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %03d: sel1=0, sel2=0 (select d0), d0=1", test_num);
        sel1 = 0; sel2 = 0;
        d0 = 1; d1 = 0; d2 = 0; d3 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %03d: sel1=0, sel2=1 (select d1), d1=0", test_num);
        sel1 = 0; sel2 = 1;
        d0 = 1; d1 = 0; d2 = 1; d3 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %03d: sel1=0, sel2=1 (select d1), d1=1", test_num);
        sel1 = 0; sel2 = 1;
        d0 = 0; d1 = 1; d2 = 0; d3 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %03d: sel1=1, sel2=0 (select d2), d2=0", test_num);
        sel1 = 1; sel2 = 0;
        d0 = 1; d1 = 1; d2 = 0; d3 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %03d: sel1=1, sel2=0 (select d2), d2=1", test_num);
        sel1 = 1; sel2 = 0;
        d0 = 0; d1 = 0; d2 = 1; d3 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %03d: sel1=1, sel2=1 (select d3), d3=0", test_num);
        sel1 = 1; sel2 = 1;
        d0 = 1; d1 = 1; d2 = 1; d3 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %03d: sel1=1, sel2=1 (select d3), d3=1", test_num);
        sel1 = 1; sel2 = 1;
        d0 = 0; d1 = 0; d2 = 0; d3 = 1;
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
