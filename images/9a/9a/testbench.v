`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in0;
    reg [7:0] data_in1;
    reg [7:0] data_in2;
    reg [7:0] data_in3;
    reg rotate_right;
    reg [1:0] select;
    reg shift_left;
    reg shift_right;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in0(data_in0),
        .data_in1(data_in1),
        .data_in2(data_in2),
        .data_in3(data_in3),
        .rotate_right(rotate_right),
        .select(select),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .data_out(data_out)
    );
    task reset_signals;

        begin
            data_in0 = 8'h0;
            data_in1 = 8'h0;
            data_in2 = 8'h0;
            data_in3 = 8'h0;
            select = 2'b00;
            shift_left = 1'b0;
            shift_right = 1'b0;
            rotate_right = 1'b0;
            #5;
        end
        endtask

    task testcase001;

        begin
            reset_signals();
            test_num = 1;
            data_in0 = 8'hAA;
            select = 2'b00;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            reset_signals();
            test_num = 2;
            data_in1 = 8'hBB;
            select = 2'b01;
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase003;

        begin
            reset_signals();
            test_num = 3;
            data_in2 = 8'hCC;
            select = 2'b10;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase004;

        begin
            reset_signals();
            test_num = 4;
            data_in3 = 8'hDD;
            select = 2'b11;
            #1;

            check_outputs(8'hDD);
        end
        endtask

    task testcase005;

        begin
            reset_signals();
            test_num = 5;
            data_in0 = 8'h81;
            select = 2'b00;
            shift_left = 1'b1;

            #1;


            check_outputs(8'h02);
        end
        endtask

    task testcase006;

        begin
            reset_signals();
            test_num = 6;
            data_in1 = 8'h81;
            select = 2'b01;
            shift_right = 1'b1;

            #1;


            check_outputs(8'h40);
        end
        endtask

    task testcase007;

        begin
            reset_signals();
            test_num = 7;
            data_in2 = 8'h01;
            select = 2'b10;
            rotate_right = 1'b1;

            #1;


            check_outputs(8'h80);
        end
        endtask

    task testcase008;

        begin
            reset_signals();
            test_num = 8;
            data_in3 = 8'hA5;
            select = 2'b11;
            rotate_right = 1'b1;

            #1;


            check_outputs(8'hD2);
        end
        endtask

    task testcase009;

        begin
            reset_signals();
            test_num = 9;
            data_in0 = 8'hFF;
            select = 2'b00;
            shift_left = 1'b1;
            shift_right = 1'b1;


            #1;



            check_outputs(8'hFE);
        end
        endtask

    task testcase010;

        begin
            reset_signals();
            test_num = 10;
            data_in1 = 8'hFF;
            select = 2'b01;
            shift_left = 1'b1;
            #1;

            check_outputs(8'hFE);
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
        input [7:0] expected_data_out;
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
