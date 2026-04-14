`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg [7:0] c;
    wire c1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .c1(c1)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs LOW", test_num);
        a = 1'b0;
        b = 1'b0;
        c = 8'h00;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input 'a' is HIGH", test_num);
        a = 1'b1;
        b = 1'b0;
        c = 8'h00;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input 'b' is HIGH", test_num);
        a = 1'b0;
        b = 1'b1;
        c = 8'h00;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input 'c' is all HIGH (8'hFF)", test_num);
        a = 1'b0;
        b = 1'b0;
        c = 8'hFF;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input 'c' is almost all HIGH (8'hFE)", test_num);
        a = 1'b0;
        b = 1'b0;
        c = 8'hFE;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple conditions met (a and b HIGH)", test_num);
        a = 1'b1;
        b = 1'b1;
        c = 8'h00;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All conditions met", test_num);
        a = 1'b1;
        b = 1'b1;
        c = 8'hFF;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Random pattern for c, a and b LOW", test_num);
        a = 1'b0;
        b = 1'b0;
        c = 8'hA5;
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
        input expected_c1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c1 === (expected_c1 ^ c1 ^ expected_c1)) begin
                $display("PASS");
                $display("  Outputs: c1=%b",
                         c1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c1=%b",
                         expected_c1);
                $display("  Got:      c1=%b",
                         c1);
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
