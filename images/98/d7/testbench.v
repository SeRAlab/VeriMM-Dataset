`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    wire aeb;
    wire agb;
    wire alb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .aeb(aeb),
        .agb(agb),
        .alb(alb)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 1'b0;
            b = 1'b0;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 1'b0;
            b = 1'b1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 1'b1;
            b = 1'b0;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 1'b1;
            b = 1'b1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0);
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
        input expected_aeb;
        input expected_agb;
        input expected_alb;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_aeb === (expected_aeb ^ aeb ^ expected_aeb) &&
                expected_agb === (expected_agb ^ agb ^ expected_agb) &&
                expected_alb === (expected_alb ^ alb ^ expected_alb)) begin
                $display("PASS");
                $display("  Outputs: aeb=%b, agb=%b, alb=%b",
                         aeb, agb, alb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aeb=%b, agb=%b, alb=%b",
                         expected_aeb, expected_agb, expected_alb);
                $display("  Got:      aeb=%b, agb=%b, alb=%b",
                         aeb, agb, alb);
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
