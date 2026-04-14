`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ctrl;
    reg [3:0] data_in;
    wire [1:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .data_in(data_in),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            ctrl = 2'b00;
            data_in = 4'b1111;
            $display("Test %0d: Shift Left (ctrl=00), data_in=4'b1111", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            ctrl = 2'b00;
            data_in = 4'b0101;
            $display("Test %0d: Shift Left (ctrl=00), data_in=4'b0101", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            ctrl = 2'b01;
            data_in = 4'b1011;
            $display("Test %0d: AND with 3 (ctrl=01), data_in=4'b1011", test_num);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            ctrl = 2'b01;
            data_in = 4'b1110;
            $display("Test %0d: AND with 3 (ctrl=01), data_in=4'b1110", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            ctrl = 2'b10;
            data_in = 4'b1111;
            $display("Test %0d: Invert (ctrl=10), data_in=4'b1111", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            ctrl = 2'b10;
            data_in = 4'b1100;
            $display("Test %0d: Invert (ctrl=10), data_in=4'b1100", test_num);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            ctrl = 2'b10;
            data_in = 4'b1010;
            $display("Test %0d: Invert (ctrl=10), data_in=4'b1010", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            ctrl = 2'b11;
            data_in = 4'b0000;
            $display("Test %0d: OR with 3 (ctrl=11), data_in=4'b0000", test_num);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            ctrl = 2'b11;
            data_in = 4'b1100;
            $display("Test %0d: OR with 3 (ctrl=11), data_in=4'b1100", test_num);
            #1;

            check_outputs(2'b11);
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
        input [1:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
