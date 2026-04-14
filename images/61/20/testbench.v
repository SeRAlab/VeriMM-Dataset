`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in0;
    reg [7:0] data_in1;
    reg [7:0] data_in2;
    reg [7:0] data_in3;
    reg sel0;
    reg sel1;
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
        .sel0(sel0),
        .sel1(sel1),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select data_in0", test_num);
            data_in0 = 8'hAA;
            data_in1 = 8'h55;
            data_in2 = 8'h00;
            data_in3 = 8'hFF;
            sel1 = 1'b0;
            sel0 = 1'b0;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select data_in1", test_num);
            data_in0 = 8'h11;
            data_in1 = 8'h22;
            data_in2 = 8'h33;
            data_in3 = 8'h44;
            sel1 = 1'b0;
            sel0 = 1'b1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select data_in2", test_num);
            data_in0 = 8'hDE;
            data_in1 = 8'hAD;
            data_in2 = 8'hBE;
            data_in3 = 8'hEF;
            sel1 = 1'b1;
            sel0 = 1'b0;
            #1;

            check_outputs(8'hBE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select data_in3", test_num);
            data_in0 = 8'h01;
            data_in1 = 8'h02;
            data_in2 = 8'h03;
            data_in3 = 8'h04;
            sel1 = 1'b1;
            sel0 = 1'b1;
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Check output changes when input changes (sel=01)", test_num);
            data_in0 = 8'h00;
            data_in1 = 8'hA5;
            data_in2 = 8'h00;
            data_in3 = 8'h00;
            sel1 = 1'b0;
            sel0 = 1'b1;
            #5;
            data_in1 = 8'h5A;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All inputs same value", test_num);
            data_in0 = 8'hFF;
            data_in1 = 8'hFF;
            data_in2 = 8'hFF;
            data_in3 = 8'hFF;
            sel1 = 1'b1;
            sel0 = 1'b0;
            #1;

            check_outputs(8'hFF);
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
