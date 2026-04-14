`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in_signal_1;
    reg in_signal_2;
    reg in_signal_3;
    reg in_signal_4;
    reg in_signal_5;
    wire out_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_signal_1(in_signal_1),
        .in_signal_2(in_signal_2),
        .in_signal_3(in_signal_3),
        .in_signal_4(in_signal_4),
        .in_signal_5(in_signal_5),
        .out_signal(out_signal)
    );
    task testcase001;

    begin
        test_num = 1;
        in_signal_1 = 0; in_signal_2 = 0; in_signal_3 = 0; in_signal_4 = 0; in_signal_5 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in_signal_1 = 1; in_signal_2 = 0; in_signal_3 = 0; in_signal_4 = 0; in_signal_5 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in_signal_1 = 0; in_signal_2 = 1; in_signal_3 = 0; in_signal_4 = 0; in_signal_5 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in_signal_1 = 1; in_signal_2 = 1; in_signal_3 = 0; in_signal_4 = 0; in_signal_5 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in_signal_1 = 0; in_signal_2 = 0; in_signal_3 = 1; in_signal_4 = 0; in_signal_5 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in_signal_1 = 0; in_signal_2 = 0; in_signal_3 = 0; in_signal_4 = 1; in_signal_5 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in_signal_1 = 0; in_signal_2 = 0; in_signal_3 = 0; in_signal_4 = 0; in_signal_5 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in_signal_1 = 1; in_signal_2 = 1; in_signal_3 = 1; in_signal_4 = 1; in_signal_5 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        in_signal_1 = 0; in_signal_2 = 1; in_signal_3 = 0; in_signal_4 = 1; in_signal_5 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        in_signal_1 = 1; in_signal_2 = 0; in_signal_3 = 1; in_signal_4 = 0; in_signal_5 = 1;
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
        testcase009();
        testcase010();
        
        
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
        input expected_out_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_signal === (expected_out_signal ^ out_signal ^ expected_out_signal)) begin
                $display("PASS");
                $display("  Outputs: out_signal=%b",
                         out_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_signal=%b",
                         expected_out_signal);
                $display("  Got:      out_signal=%b",
                         out_signal);
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
