`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg data;
    reg en;
    reg reset;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .en(en),
        .reset(reset),
        .q(q)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Asynchronous reset priority", test_num);
        data = 1;
        en = 1;
        reset = 0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Transparent mode - Data High", test_num);
        reset = 0; #5;
        reset = 1;
        en = 1;
        data = 1;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Transparent mode - Data Low", test_num);
        reset = 0; #5;
        reset = 1;
        en = 1;
        data = 0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Hold mode (Enable 1 -> 0 while holding 1)", test_num);
        reset = 0; #5;
        reset = 1;
        data = 1;
        en = 1;
        #5;
        en = 0;
        data = 0;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Hold mode (Enable 1 -> 0 while holding 0)", test_num);
        reset = 0; #5;
        reset = 1;
        data = 0;
        en = 1;
        #5;
        en = 0;
        data = 1;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset while latch is in hold mode", test_num);
        reset = 0; #5;
        reset = 1;
        data = 1;
        en = 1;
        #5;
        en = 0;
        #5;
        reset = 0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Data toggle while en=0", test_num);
        reset = 0; #5;
        reset = 1;
        data = 1;
        en = 1;
        #5;
        en = 0;
        #2;
        data = 0; #2;
        data = 1; #2;
        data = 0; #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset override during activity", test_num);
        reset = 0;
        en = 1;
        data = 1;
        #5;
        data = 0;
        #5;
        en = 0;
        data = 1;
        #5;
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
