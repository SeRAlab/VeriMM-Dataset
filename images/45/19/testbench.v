`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in_signal;
    wire [5:0] out_signal1;
    wire [9:0] out_signal2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_signal(in_signal),
        .out_signal1(out_signal1),
        .out_signal2(out_signal2)
    );
    task testcase001;

        begin
            test_num = 1;
            in_signal = 16'h0000;
            #1;

            check_outputs(6'h00, 10'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in_signal = 16'hFFFF;
            #1;

            check_outputs(6'h3F, 10'h3FF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in_signal = 16'hAAAA;

            #1;


            check_outputs(6'h2A, 10'h2AA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in_signal = 16'h5555;

            #1;


            check_outputs(6'h15, 10'h155);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in_signal = 16'h1234;

            #1;


            check_outputs(6'h04, 10'h234);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in_signal = 16'hFC00;
            #1;

            check_outputs(6'h3F, 10'h000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in_signal = 16'h03FF;
            #1;

            check_outputs(6'h00, 10'h3FF);
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
        input [5:0] expected_out_signal1;
        input [9:0] expected_out_signal2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_signal1 === (expected_out_signal1 ^ out_signal1 ^ expected_out_signal1) &&
                expected_out_signal2 === (expected_out_signal2 ^ out_signal2 ^ expected_out_signal2)) begin
                $display("PASS");
                $display("  Outputs: out_signal1=%h, out_signal2=%h",
                         out_signal1, out_signal2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_signal1=%h, out_signal2=%h",
                         expected_out_signal1, expected_out_signal2);
                $display("  Got:      out_signal1=%h, out_signal2=%h",
                         out_signal1, out_signal2);
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
