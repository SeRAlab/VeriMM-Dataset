`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg in_enq__ENA;
    reg [31:0] in_enq_v;
    reg nRST;
    reg out_deq__ENA;
    wire in_enq__RDY;
    wire out_deq__RDY;
    wire [31:0] out_first;
    wire out_first__RDY;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .in_enq__ENA(in_enq__ENA),
        .in_enq_v(in_enq_v),
        .nRST(nRST),
        .out_deq__ENA(out_deq__ENA),
        .in_enq__RDY(in_enq__RDY),
        .out_deq__RDY(out_deq__RDY),
        .out_first(out_first),
        .out_first__RDY(out_first__RDY)
    );
    task cycle;

        begin
            @(posedge CLK);
            #1;
        end
        endtask

    task reset_system;

        begin
            nRST = 0;
            in_enq__ENA = 0;
            out_deq__ENA = 0;
            in_enq_v = 0;
            repeat(2) cycle();
            nRST = 1;
            cycle();
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_system();

            #1;


            check_outputs(1'b1, 1'b0, 32'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_system();

            in_enq__ENA = 1;
            in_enq_v = 32'hABCDEF01;
            cycle();
            in_enq__ENA = 0;


            #1;



            check_outputs(1'b1, 1'b1, 32'hABCDEF01, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_system();


            in_enq__ENA = 1; in_enq_v = 32'h11111111;
            cycle();

            in_enq__ENA = 1; in_enq_v = 32'h22222222;
            cycle();
            in_enq__ENA = 0;


            #1;



            check_outputs(1'b1, 1'b1, 32'h11111111, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_system();


            in_enq__ENA = 1; in_enq_v = 32'hDEADBEEF;
            cycle();
            in_enq__ENA = 0;


            out_deq__ENA = 1;
            cycle();
            out_deq__ENA = 0;


            #1;



            check_outputs(1'b1, 1'b0, 32'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_system();


            in_enq__ENA = 1; in_enq_v = 32'h0000000A;
            cycle();

            in_enq__ENA = 1; in_enq_v = 32'h00000014;
            cycle();
            in_enq__ENA = 0;


            out_deq__ENA = 1;
            cycle();
            out_deq__ENA = 0;


            #1;



            check_outputs(1'b1, 1'b1, 32'h00000014, 1'b1);
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
        input expected_in_enq__RDY;
        input expected_out_deq__RDY;
        input [31:0] expected_out_first;
        input expected_out_first__RDY;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_in_enq__RDY === (expected_in_enq__RDY ^ in_enq__RDY ^ expected_in_enq__RDY) &&
                expected_out_deq__RDY === (expected_out_deq__RDY ^ out_deq__RDY ^ expected_out_deq__RDY) &&
                expected_out_first === (expected_out_first ^ out_first ^ expected_out_first) &&
                expected_out_first__RDY === (expected_out_first__RDY ^ out_first__RDY ^ expected_out_first__RDY)) begin
                $display("PASS");
                $display("  Outputs: in_enq__RDY=%b, out_deq__RDY=%b, out_first=%h, out_first__RDY=%b",
                         in_enq__RDY, out_deq__RDY, out_first, out_first__RDY);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: in_enq__RDY=%b, out_deq__RDY=%b, out_first=%h, out_first__RDY=%b",
                         expected_in_enq__RDY, expected_out_deq__RDY, expected_out_first, expected_out_first__RDY);
                $display("  Got:      in_enq__RDY=%b, out_deq__RDY=%b, out_first=%h, out_first__RDY=%b",
                         in_enq__RDY, out_deq__RDY, out_first, out_first__RDY);
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
