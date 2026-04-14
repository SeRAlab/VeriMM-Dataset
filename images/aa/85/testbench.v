`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in_signal;
    reg reset;
    wire [2:0] out_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_signal(in_signal),
        .reset(reset),
        .out_signal(out_signal)
    );
    task testcase001;

        begin
            test_num = 1;
            reset = 1;
            in_signal = 4'd10;
            #10;
            $display("Test %0d: Reset Asserted (Input 10)", test_num);
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset = 0;
            in_signal = 4'd0;
            #10;
            $display("Test %0d: Input 0 (0 + 5 = 5)", test_num);
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset = 0;
            in_signal = 4'd1;
            #10;
            $display("Test %0d: Input 1 (1 + 5 = 6)", test_num);
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset = 0;
            in_signal = 4'd2;
            #10;
            $display("Test %0d: Input 2 (2 + 5 = 7)", test_num);
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset = 0;
            in_signal = 4'd3;
            #10;
            $display("Test %0d: Input 3 (3 + 5 = 8, 3-bit overflow)", test_num);
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset = 0;
            in_signal = 4'd11;
            #10;
            $display("Test %0d: Input 11 (11 + 5 = 16, 3-bit overflow)", test_num);
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset = 0;
            in_signal = 4'd15;
            #10;
            $display("Test %0d: Input 15 (15 + 5 = 20)", test_num);
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset = 1;
            in_signal = 4'd15;
            #10;
            $display("Test %0d: Reset Asserted (Input 15)", test_num);
            #1;

            check_outputs(3'b000);
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
