`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] input_signal;
    wire [31:0] filtered_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_signal(input_signal),
        .filtered_signal(filtered_signal)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Input > 10 (Value 25)", test_num);
            input_signal = 32'd25;
            #1;

            check_outputs(32'd25);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Input <= 10 (Value 5), should retain 25", test_num);

            input_signal = 32'd25;
            #10;

            input_signal = 32'd5;
            #1;

            check_outputs(32'd25);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Boundary 10, should retain previous (100)", test_num);
            input_signal = 32'd100;
            #10;
            input_signal = 32'd10;
            #1;

            check_outputs(32'd100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Boundary 11, should update", test_num);
            input_signal = 32'd50;
            #10;
            input_signal = 32'd11;
            #1;

            check_outputs(32'd11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Input 0, should retain previous (11 from TC004)", test_num);

            input_signal = 32'd11;
            #10;
            input_signal = 32'd0;
            #1;

            check_outputs(32'd11);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Large 32-bit value update", test_num);
            input_signal = 32'hFFFF_FF00;
            #1;

            check_outputs(32'hFFFF_FF00);
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
        input [31:0] expected_filtered_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_filtered_signal === (expected_filtered_signal ^ filtered_signal ^ expected_filtered_signal)) begin
                $display("PASS");
                $display("  Outputs: filtered_signal=%h",
                         filtered_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: filtered_signal=%h",
                         expected_filtered_signal);
                $display("  Got:      filtered_signal=%h",
                         filtered_signal);
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
