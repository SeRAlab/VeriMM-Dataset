`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg [7:0] in;
    reg sel_b1;
    reg sel_b2;
    wire [3:0] out_sum;
    wire [2:0] pos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .in(in),
        .sel_b1(sel_b1),
        .sel_b2(sel_b2),
        .out_sum(out_sum),
        .pos(pos)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Highest bit 7, Mux Select A (sel=00)", test_num);
            a = 1; b = 0; sel_b1 = 0; sel_b2 = 0; in = 8'h80;

            #1;


            check_outputs(4'd8, 3'd7);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Bit 6, Mux Select B (sel=11)", test_num);
            a = 0; b = 1; sel_b1 = 1; sel_b2 = 1; in = 8'h40;

            #1;


            check_outputs(4'd7, 3'd6);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Bit 5, Mux Select A (sel=10)", test_num);
            a = 1; b = 0; sel_b1 = 1; sel_b2 = 0; in = 8'h20;

            #1;


            check_outputs(4'd6, 3'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Bit 4, Mux Select A (sel=01)", test_num);
            a = 0; b = 1; sel_b1 = 0; sel_b2 = 1; in = 8'h10;

            #1;


            check_outputs(4'd4, 3'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Bit 3, Mux Select B (sel=11)", test_num);
            a = 1; b = 0; sel_b1 = 1; sel_b2 = 1; in = 8'h08;

            #1;


            check_outputs(4'd3, 3'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Priority test (multiple bits 7 and 0), Mux Select A", test_num);
            a = 1; b = 0; sel_b1 = 0; sel_b2 = 0; in = 8'h81;

            #1;


            check_outputs(4'd8, 3'd7);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Bit 2, Mux Select B (sel=11)", test_num);
            a = 0; b = 1; sel_b1 = 1; sel_b2 = 1; in = 8'h04;

            #1;


            check_outputs(4'd3, 3'd2);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Bit 1, Mux Select A (sel=00)", test_num);
            a = 1; b = 0; sel_b1 = 0; sel_b2 = 0; in = 8'h02;

            #1;


            check_outputs(4'd2, 3'd1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Bit 0, Mux Select B (sel=11)", test_num);
            a = 1; b = 1; sel_b1 = 1; sel_b2 = 1; in = 8'h01;

            #1;


            check_outputs(4'd1, 3'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: No bits active, Mux Select A", test_num);
            a = 0; b = 1; sel_b1 = 0; sel_b2 = 0; in = 8'h00;

            #1;


            check_outputs(4'd0, 3'd0);
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
        input [3:0] expected_out_sum;
        input [2:0] expected_pos;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_sum === (expected_out_sum ^ out_sum ^ expected_out_sum) &&
                expected_pos === (expected_pos ^ pos ^ expected_pos)) begin
                $display("PASS");
                $display("  Outputs: out_sum=%h, pos=%h",
                         out_sum, pos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_sum=%h, pos=%h",
                         expected_out_sum, expected_pos);
                $display("  Got:      out_sum=%h, pos=%h",
                         out_sum, pos);
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
