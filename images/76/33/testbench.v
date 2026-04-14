`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] col;
    reg [3:0] k_map;
    reg [1:0] row;
    wire f_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .col(col),
        .k_map(k_map),
        .row(row),
        .f_out(f_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            k_map = 4'b0000;
            row = 2'b00;
            col = 2'b00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            k_map = 4'b1111;
            row = 2'b01;
            col = 2'b01;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            k_map = 4'b0001;
            row = 2'b00;
            col = 2'b00;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            k_map = 4'b0010;
            row = 2'b00;
            col = 2'b01;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            k_map = 4'b0100;
            row = 2'b01;
            col = 2'b00;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            k_map = 4'b1000;
            row = 2'b01;
            col = 2'b01;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            k_map = 4'b1010;
            row = 2'b00;
            col = 2'b01;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            k_map = 4'b1010;
            row = 2'b00;
            col = 2'b00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            k_map = 4'b0100;
            row = 2'b10;
            col = 2'b00;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            k_map = 4'b1101;
            row = 2'b01;
            col = 2'b01;
            #1;

            check_outputs(1'b1);
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
        input expected_f_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_f_out === (expected_f_out ^ f_out ^ expected_f_out)) begin
                $display("PASS");
                $display("  Outputs: f_out=%b",
                         f_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f_out=%b",
                         expected_f_out);
                $display("  Got:      f_out=%b",
                         f_out);
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
