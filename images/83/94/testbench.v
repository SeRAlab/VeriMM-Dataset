`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] input_signal;
    wire [7:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_signal(input_signal),
        .output_signal(output_signal)
    );
    task testcase001;

    begin
        test_num = 1;
        input_signal = 8'h00;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        input_signal = 8'hFF;
        #1;

        check_outputs(8'hC0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        input_signal = 8'h55;
        #1;

        check_outputs(8'h4A);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        input_signal = 8'hAA;
        #1;

        check_outputs(8'h85);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        input_signal = 8'hC0;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        input_signal = 8'h30;
        #1;

        check_outputs(8'hCF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        input_signal = 8'h0F;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        input_signal = 8'h96;
        #1;

        check_outputs(8'h49);
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
        input [7:0] expected_output_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_signal === (expected_output_signal ^ output_signal ^ expected_output_signal)) begin
                $display("PASS");
                $display("  Outputs: output_signal=%h",
                         output_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_signal=%h",
                         expected_output_signal);
                $display("  Got:      output_signal=%h",
                         output_signal);
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
