`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    reg d;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .q(q)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs LOW (0000)", test_num);
        a = 0; b = 0; c = 0; d = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input d is HIGH (0001)", test_num);
        a = 0; b = 0; c = 0; d = 1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input c is HIGH (0010)", test_num);
        a = 0; b = 0; c = 1; d = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Inputs c, d are HIGH (0011)", test_num);
        a = 0; b = 0; c = 1; d = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input b is HIGH (0100)", test_num);
        a = 0; b = 1; c = 0; d = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Inputs b, d are HIGH (0101)", test_num);
        a = 0; b = 1; c = 0; d = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Inputs b, c are HIGH (0110)", test_num);
        a = 0; b = 1; c = 1; d = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Inputs b, c, d are HIGH (0111)", test_num);
        a = 0; b = 1; c = 1; d = 1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input a is HIGH (1000)", test_num);
        a = 1; b = 0; c = 0; d = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Inputs a, d are HIGH (1001)", test_num);
        a = 1; b = 0; c = 0; d = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Inputs a, c are HIGH (1010)", test_num);
        a = 1; b = 0; c = 1; d = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Inputs a, c, d are HIGH (1011)", test_num);
        a = 1; b = 0; c = 1; d = 1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Inputs a, b are HIGH (1100)", test_num);
        a = 1; b = 1; c = 0; d = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase014;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Inputs a, b, d are HIGH (1101)", test_num);
        a = 1; b = 1; c = 0; d = 1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase015;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Inputs a, b, c are HIGH (1110)", test_num);
        a = 1; b = 1; c = 1; d = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase016;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs HIGH (1111)", test_num);
        a = 1; b = 1; c = 1; d = 1;
        #1;

        check_outputs(1);
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
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input expected_q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%b",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b",
                         expected_q);
                $display("  Got:      q=%b",
                         q);
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
