`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg control_signal;
    reg [7:0] input_num;
    wire [7:0] shifted_num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .control_signal(control_signal),
        .input_num(input_num),
        .shifted_num(shifted_num)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Left shift 0x01", test_num);
            input_num = 8'h01;
            control_signal = 1'b1;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Left shift 0x80", test_num);
            input_num = 8'h80;
            control_signal = 1'b1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Right shift 0x02", test_num);
            input_num = 8'h02;
            control_signal = 1'b0;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Right shift 0x01", test_num);
            input_num = 8'h01;
            control_signal = 1'b0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Left shift 0x55", test_num);
            input_num = 8'h55;
            control_signal = 1'b1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Right shift 0xAA", test_num);
            input_num = 8'hAA;
            control_signal = 1'b0;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Left shift 0xFF", test_num);
            input_num = 8'hFF;
            control_signal = 1'b1;
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Right shift 0xFF", test_num);
            input_num = 8'hFF;
            control_signal = 1'b0;
            #1;

            check_outputs(8'h7F);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Left shift 0x00", test_num);
            input_num = 8'h00;
            control_signal = 1'b1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Right shift 0x00", test_num);
            input_num = 8'h00;
            control_signal = 1'b0;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_shifted_num;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_shifted_num === (expected_shifted_num ^ shifted_num ^ expected_shifted_num)) begin
                $display("PASS");
                $display("  Outputs: shifted_num=%h",
                         shifted_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shifted_num=%h",
                         expected_shifted_num);
                $display("  Got:      shifted_num=%h",
                         shifted_num);
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
