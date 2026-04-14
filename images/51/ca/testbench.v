`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg add_sub_ctrl;
    reg [7:0] b;
    reg select_ctrl;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .add_sub_ctrl(add_sub_ctrl),
        .b(b),
        .select_ctrl(select_ctrl),
        .Q(Q)
    );
    task testcase001;

        begin
            a = 8'd10;
            b = 8'd5;
            add_sub_ctrl = 1'b1;
            select_ctrl = 1'b0;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase002;

        begin
            a = 8'd20;
            b = 8'd7;
            add_sub_ctrl = 1'b1;
            select_ctrl = 1'b1;
            #1;

            check_outputs(8'd13);
        end
        endtask

    task testcase003;

        begin
            a = 8'd255;
            b = 8'd1;
            add_sub_ctrl = 1'b1;
            select_ctrl = 1'b0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase004;

        begin
            a = 8'd5;
            b = 8'd10;
            add_sub_ctrl = 1'b1;
            select_ctrl = 1'b1;
            #1;

            check_outputs(8'd251);
        end
        endtask

    task testcase005;

        begin
            a = 8'd50;
            b = 8'd50;
            add_sub_ctrl = 1'b0;
            select_ctrl = 1'b0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            a = 8'd100;
            b = 8'd20;
            add_sub_ctrl = 1'b0;
            select_ctrl = 1'b1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            a = 8'd0;
            b = 8'd0;
            add_sub_ctrl = 1'b1;
            select_ctrl = 1'b0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase008;

        begin
            a = 8'hFF;
            b = 8'hFF;
            add_sub_ctrl = 1'b1;
            select_ctrl = 1'b1;
            #1;

            check_outputs(8'd0);
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
        input [7:0] expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
