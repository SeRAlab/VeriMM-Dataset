`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] ctrl_in;
    reg [63:0] data_in;
    wire [72:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl_in(ctrl_in),
        .data_in(data_in),
        .data_out(data_out)
    );
    task calculate_expected;

        input [63:0] d;
        input [7:0] c;
        output [72:0] exp;
        begin
            exp = 73'b0;
            for (i = 0; i < 8; i = i + 1) begin
                exp[i*9 +: 8] = d[i*8 +: 8];
                exp[i*9 + 8]  = c[i];
            end
            exp[72] = 1'b0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            data_in = 64'h0;
            ctrl_in = 8'h0;
            calculate_expected(data_in, ctrl_in, expected_val);
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data_in = 64'hFFFFFFFFFFFFFFFF;
            ctrl_in = 8'hFF;
            calculate_expected(data_in, ctrl_in, expected_val);
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data_in = 64'hAAAAAAAAAAAAAAAA;
            ctrl_in = 8'h55;
            calculate_expected(data_in, ctrl_in, expected_val);
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data_in = 64'h5555555555555555;
            ctrl_in = 8'hAA;
            calculate_expected(data_in, ctrl_in, expected_val);
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data_in = 64'h0123456789ABCDEF;
            ctrl_in = 8'h00;
            calculate_expected(data_in, ctrl_in, expected_val);
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data_in = 64'h00000000000000FF;
            ctrl_in = 8'h80;
            calculate_expected(data_in, ctrl_in, expected_val);
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data_in = 64'hDEADC0DEBEEFCAFE;
            ctrl_in = 8'hA5;
            calculate_expected(data_in, ctrl_in, expected_val);
            #1;

            check_outputs(expected_val);
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
        input [72:0] expected_data_out;
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
