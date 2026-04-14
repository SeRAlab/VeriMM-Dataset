`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] fact_f;
    reg [3:0] fact_l;
    reg [3:0] set_f;
    reg [3:0] set_l;
    wire stop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .fact_f(fact_f),
        .fact_l(fact_l),
        .set_f(set_f),
        .set_l(set_l),
        .stop(stop)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Both pairs match (all zeros)", test_num);
        fact_f = 4'h0;
        fact_l = 4'h0;
        set_f  = 4'h0;
        set_l  = 4'h0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Both pairs match (all ones)", test_num);
        fact_f = 4'hF;
        fact_l = 4'hF;
        set_f  = 4'hF;
        set_l  = 4'hF;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Both pairs match (random values)", test_num);
        fact_f = 4'hA;
        fact_l = 4'h5;
        set_f  = 4'hA;
        set_l  = 4'h5;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Mismatch in fact_f only", test_num);
        fact_f = 4'h1;
        fact_l = 4'h5;
        set_f  = 4'h0;
        set_l  = 4'h5;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Mismatch in fact_l only", test_num);
        fact_f = 4'hC;
        fact_l = 4'hE;
        set_f  = 4'hC;
        set_l  = 4'hF;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Mismatch in both pairs", test_num);
        fact_f = 4'h1;
        fact_l = 4'h2;
        set_f  = 4'h3;
        set_l  = 4'h4;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Mismatch by a single bit (LSB)", test_num);
        fact_f = 4'b1010;
        fact_l = 4'b0110;
        set_f  = 4'b1011;
        set_l  = 4'b0110;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Mismatch by a single bit (MSB)", test_num);
        fact_f = 4'b1111;
        fact_l = 4'b0000;
        set_f  = 4'b1111;
        set_l  = 4'b1000;
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
        input expected_stop;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_stop === (expected_stop ^ stop ^ expected_stop)) begin
                $display("PASS");
                $display("  Outputs: stop=%b",
                         stop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stop=%b",
                         expected_stop);
                $display("  Got:      stop=%b",
                         stop);
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
