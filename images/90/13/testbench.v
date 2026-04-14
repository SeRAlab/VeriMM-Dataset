`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] comp_in1;
    reg [3:0] comp_in2;
    reg [3:0] in1;
    reg [3:0] in2;
    reg sel1;
    reg sel2;
    wire eq_out;
    wire gt_out;
    wire lt_out;
    wire [3:0] mux_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .comp_in1(comp_in1),
        .comp_in2(comp_in2),
        .in1(in1),
        .in2(in2),
        .sel1(sel1),
        .sel2(sel2),
        .eq_out(eq_out),
        .gt_out(gt_out),
        .lt_out(lt_out),
        .mux_out(mux_out)
    );
    task testcase001;

        begin

            in1 = 4'b1010;
            in2 = 4'b0101;
            sel1 = 1'b1;
            sel2 = 1'b0;
            comp_in1 = 4'd7;
            comp_in2 = 4'd7;
            $display("Running testcase001: Eq comparison and sel1=1");
            #1;

            check_outputs(1'b1, 1'b0, 1'b0, 4'b1010);
        end
        endtask

    task testcase002;

        begin

            in1 = 4'hF;
            in2 = 4'hC;
            sel1 = 1'b0;
            sel2 = 1'b1;
            comp_in1 = 4'd12;
            comp_in2 = 4'd4;
            $display("Running testcase002: Gt comparison and sel2=1");
            #1;

            check_outputs(1'b0, 1'b1, 1'b0, 4'hC);
        end
        endtask

    task testcase003;

        begin

            in1 = 4'h3;
            in2 = 4'hE;
            sel1 = 1'b1;
            sel2 = 1'b1;
            comp_in1 = 4'd2;
            comp_in2 = 4'd15;
            $display("Running testcase003: Lt comparison and sel1/sel2 priority");
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 4'h3);
        end
        endtask

    task testcase004;

        begin

            in1 = 4'hF;
            in2 = 4'hF;
            sel1 = 1'b0;
            sel2 = 1'b0;
            comp_in1 = 4'hF;
            comp_in2 = 4'h0;
            $display("Running testcase004: Max/Min Gt comparison and no selection");

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 4'h0);
        end
        endtask

    task testcase005;

        begin

            in1 = 4'h0;
            in2 = 4'h7;
            sel1 = 1'b0;
            sel2 = 1'b1;
            comp_in1 = 4'h0;
            comp_in2 = 4'hF;
            $display("Running testcase005: Min/Max Lt comparison and sel2=1");
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 4'h7);
        end
        endtask

    task testcase006;

        begin

            in1 = 4'h1;
            in2 = 4'h2;
            sel1 = 1'b1;
            sel2 = 1'b0;
            comp_in1 = 4'h0;
            comp_in2 = 4'h0;
            $display("Running testcase006: Zero Eq comparison");
            #1;

            check_outputs(1'b1, 1'b0, 1'b0, 4'h1);
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
        input expected_eq_out;
        input expected_gt_out;
        input expected_lt_out;
        input [3:0] expected_mux_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eq_out === (expected_eq_out ^ eq_out ^ expected_eq_out) &&
                expected_gt_out === (expected_gt_out ^ gt_out ^ expected_gt_out) &&
                expected_lt_out === (expected_lt_out ^ lt_out ^ expected_lt_out) &&
                expected_mux_out === (expected_mux_out ^ mux_out ^ expected_mux_out)) begin
                $display("PASS");
                $display("  Outputs: eq_out=%b, gt_out=%b, lt_out=%b, mux_out=%h",
                         eq_out, gt_out, lt_out, mux_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eq_out=%b, gt_out=%b, lt_out=%b, mux_out=%h",
                         expected_eq_out, expected_gt_out, expected_lt_out, expected_mux_out);
                $display("  Got:      eq_out=%b, gt_out=%b, lt_out=%b, mux_out=%h",
                         eq_out, gt_out, lt_out, mux_out);
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
