`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in_signal;
    wire [2:0] out_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_signal(in_signal),
        .out_signal(out_signal)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Input < 4 (Input = 0)", test_num);
        in_signal = 4'd0;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Input < 4 (Input = 2)", test_num);
        in_signal = 4'd2;
        #1;

        check_outputs(3'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Input < 4 (Input = 3)", test_num);
        in_signal = 4'd3;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Input between 4 and 7 (Input = 4)", test_num);
        in_signal = 4'd4;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Input between 4 and 7 (Input = 6)", test_num);
        in_signal = 4'd6;
        #1;

        check_outputs(3'd5);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Input between 4 and 7 (Input = 7)", test_num);
        in_signal = 4'd7;
        #1;

        check_outputs(3'd6);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Input >= 8 (Input = 8)", test_num);
        in_signal = 4'd8;
        #1;

        check_outputs(3'd6);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Input >= 8 (Input = 9)", test_num);
        in_signal = 4'd9;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Input >= 8 (Input = 10, Testing 3-bit Truncation)", test_num);
        in_signal = 4'd10;

        #1;


        check_outputs(3'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Input >= 8 (Input = 15, Max Input)", test_num);
        in_signal = 4'd15;

        #1;


        check_outputs(3'd5);
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
        input [2:0] expected_out_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_signal === (expected_out_signal ^ out_signal ^ expected_out_signal)) begin
                $display("PASS");
                $display("  Outputs: out_signal=%h",
                         out_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_signal=%h",
                         expected_out_signal);
                $display("  Got:      out_signal=%h",
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
