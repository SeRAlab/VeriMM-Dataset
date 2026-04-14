`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg p1;
    reg p2;
    reg p3;
    reg p4;
    reg p5;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .p1(p1),
        .p2(p2),
        .p3(p3),
        .p4(p4),
        .p5(p5),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All inputs LOW (Expect y=1)", test_num);
        p1 = 0; p2 = 0; p3 = 0; p4 = 0; p5 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: p1 HIGH (Expect y=0)", test_num);
        p1 = 1; p2 = 0; p3 = 0; p4 = 0; p5 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: p2 HIGH (Expect y=0)", test_num);
        p1 = 0; p2 = 1; p3 = 0; p4 = 0; p5 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: p3 HIGH (Expect y=0)", test_num);
        p1 = 0; p2 = 0; p3 = 1; p4 = 0; p5 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: p4 HIGH (Expect y=0)", test_num);
        p1 = 0; p2 = 0; p3 = 0; p4 = 1; p5 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: p5 HIGH (Expect y=0)", test_num);
        p1 = 0; p2 = 0; p3 = 0; p4 = 0; p5 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Multiple inputs HIGH (Expect y=0)", test_num);
        p1 = 1; p2 = 0; p3 = 1; p4 = 0; p5 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: All inputs HIGH (Expect y=0)", test_num);
        p1 = 1; p2 = 1; p3 = 1; p4 = 1; p5 = 1;
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
        input expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%b",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b",
                         expected_y);
                $display("  Got:      y=%b",
                         y);
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
