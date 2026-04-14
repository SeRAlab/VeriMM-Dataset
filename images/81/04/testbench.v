`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ck;
    reg r_l;
    reg sd;
    wire so;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ck(ck),
        .r_l(r_l),
        .sd(sd),
        .so(so)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: Reset behavior", test_num);
        r_l = 0;
        ck = 1;
        sd = 0;
        #10;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: Transparent mode (ck=0) with sd=0", test_num);

        r_l = 0; #5;
        r_l = 1;

        ck = 0;
        sd = 0;
        #10;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: Transparent mode (ck=0) with sd=1", test_num);

        r_l = 0; #5;
        r_l = 1;

        ck = 0;
        sd = 1;
        #10;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: Hold mode capturing sd=1 (so=0)", test_num);

        r_l = 0; #5;
        r_l = 1;

        ck = 0;
        sd = 1;
        #10;

        ck = 1;
        #5;
        sd = 0;
        #10;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: Hold mode capturing sd=0 (so=1)", test_num);

        r_l = 0; #5;
        r_l = 1;

        ck = 0;
        sd = 0;
        #10;

        ck = 1;
        #5;
        sd = 1;
        #10;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %0d: Asynchronous reset during hold mode", test_num);

        r_l = 0; #5;
        r_l = 1;
        ck = 0;
        sd = 0; #5;
        ck = 1; #5;


        r_l = 0;
        #10;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest Case %0d: Multiple toggles in transparent mode", test_num);
        r_l = 0; #5;
        r_l = 1;
        ck = 0;

        sd = 1; #5;
        sd = 0; #5;
        sd = 1; #5;
        sd = 0; #5;

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
        input expected_so;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_so === (expected_so ^ so ^ expected_so)) begin
                $display("PASS");
                $display("  Outputs: so=%b",
                         so);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: so=%b",
                         expected_so);
                $display("  Got:      so=%b",
                         so);
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
