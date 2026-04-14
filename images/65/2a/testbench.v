`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in_0;
    reg [7:0] data_in_1;
    reg [7:0] data_in_2;
    reg [7:0] data_in_3;
    reg [1:0] sel_0;
    reg [1:0] sel_1;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in_0(data_in_0),
        .data_in_1(data_in_1),
        .data_in_2(data_in_2),
        .data_in_3(data_in_3),
        .sel_0(sel_0),
        .sel_1(sel_1),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            data_in_0 = 8'hAA; data_in_1 = 8'hBB; data_in_2 = 8'hCC; data_in_3 = 8'hDD;

            sel_0 = 2'b00; sel_1 = 2'b00;
            #10;
            $display("Testcase %0d: Selecting data_in_0 (Expect AA)", test_num);
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data_in_0 = 8'hAA; data_in_1 = 8'hBB; data_in_2 = 8'hCC; data_in_3 = 8'hDD;

            sel_0 = 2'b01; sel_1 = 2'b00;
            #10;
            $display("Testcase %0d: Selecting data_in_1 (Expect BB)", test_num);
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data_in_0 = 8'hAA; data_in_1 = 8'hBB; data_in_2 = 8'hCC; data_in_3 = 8'hDD;

            sel_0 = 2'b00; sel_1 = 2'b01;
            #10;
            $display("Testcase %0d: Selecting data_in_2 (Expect CC)", test_num);
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data_in_0 = 8'hAA; data_in_1 = 8'hBB; data_in_2 = 8'hCC; data_in_3 = 8'hDD;

            sel_0 = 2'b10; sel_1 = 2'b01;
            #10;
            $display("Testcase %0d: Selecting data_in_3 (Expect DD)", test_num);
            #1;

            check_outputs(8'hDD);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;


            data_in_0 = 8'h11; data_in_1 = 8'h22; data_in_2 = 8'hFF; data_in_3 = 8'hFF;
            sel_0 = 2'b10;
            sel_1 = 2'b00;
            #10;
            $display("Testcase %0d: Verification of hierarchical isolation (Expect 11)", test_num);
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;

            data_in_0 = 8'h55; data_in_1 = 8'h55; data_in_2 = 8'h55; data_in_3 = 8'h55;
            sel_0 = 2'b11; sel_1 = 2'b11;
            #10;
            $display("Testcase %0d: Uniform input check (Expect 55)", test_num);
            #1;

            check_outputs(8'h55);
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
