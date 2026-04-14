`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] arate;
    reg [9:0] eg;
    reg keyoff_now;
    reg keyon_now;
    reg [4:0] rate1;
    reg [4:0] rate2;
    reg [3:0] rrate;
    reg [3:0] sl;
    reg [2:0] ssg_eg;
    reg ssg_en;
    reg ssg_inv_in;
    reg [2:0] state_in;
    wire [4:0] base_rate;
    wire pg_rst;
    wire ssg_inv_out;
    wire [2:0] state_next;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .arate(arate),
        .eg(eg),
        .keyoff_now(keyoff_now),
        .keyon_now(keyon_now),
        .rate1(rate1),
        .rate2(rate2),
        .rrate(rrate),
        .sl(sl),
        .ssg_eg(ssg_eg),
        .ssg_en(ssg_en),
        .ssg_inv_in(ssg_inv_in),
        .state_in(state_in),
        .base_rate(base_rate),
        .pg_rst(pg_rst),
        .ssg_inv_out(ssg_inv_out),
        .state_next(state_next)
    );
    task reset_inputs;

        begin
            arate = 0; eg = 1023; keyoff_now = 0; keyon_now = 0;
            rate1 = 0; rate2 = 0; rrate = 0; sl = 0;
            ssg_eg = 0; ssg_en = 0; ssg_inv_in = 0; state_in = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_inputs();
            keyon_now = 1;
            state_in = 0;
            arate = 5'h10;

            #1;


            check_outputs(5'h10, 1'b1, 1'b0, 3'h1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_inputs();
            state_in = 3'h1;
            eg = 10'd512;
            arate = 5'h15;

            #1;


            check_outputs(5'h15, 1'b0, 1'b0, 3'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_inputs();
            state_in = 3'h1;
            eg = 10'd0;
            arate = 5'h15;

            #1;


            check_outputs(5'h15, 1'b0, 1'b0, 3'h2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_inputs();
            state_in = 3'h2;
            eg = 10'd100;
            rate1 = 5'h0A;
            sl = 4'h8;

            #1;


            check_outputs(5'h0A, 1'b0, 1'b0, 3'h2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_inputs();
            state_in = 3'h2;
            sl = 4'h4;
            eg = 10'd128;
            rate1 = 5'h0A;

            #1;


            check_outputs(5'h0A, 1'b0, 1'b0, 3'h3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_inputs();
            state_in = 3'h3;
            rate2 = 5'h05;

            #1;


            check_outputs(5'h05, 1'b0, 1'b0, 3'h3);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_inputs();
            keyoff_now = 1;
            state_in = 3'h3;
            rrate = 4'h8;

            #1;


            check_outputs(5'h11, 1'b0, 1'b0, 3'h4);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_inputs();
            state_in = 3'h4;
            rrate = 4'h7;

            #1;


            check_outputs(5'h0F, 1'b0, 1'b0, 3'h4);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_inputs();
            ssg_en = 1;
            ssg_inv_in = 1;
            state_in = 3'h1;

            #1;


            check_outputs(5'h00, 1'b0, 1'b1, 3'h1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_inputs();
            state_in = 3'h0;

            #1;


            check_outputs(5'h00, 1'b0, 1'b0, 3'h0);
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
        input [4:0] expected_base_rate;
        input expected_pg_rst;
        input expected_ssg_inv_out;
        input [2:0] expected_state_next;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_base_rate === (expected_base_rate ^ base_rate ^ expected_base_rate) &&
                expected_pg_rst === (expected_pg_rst ^ pg_rst ^ expected_pg_rst) &&
                expected_ssg_inv_out === (expected_ssg_inv_out ^ ssg_inv_out ^ expected_ssg_inv_out) &&
                expected_state_next === (expected_state_next ^ state_next ^ expected_state_next)) begin
                $display("PASS");
                $display("  Outputs: base_rate=%h, pg_rst=%b, ssg_inv_out=%b, state_next=%h",
                         base_rate, pg_rst, ssg_inv_out, state_next);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: base_rate=%h, pg_rst=%b, ssg_inv_out=%b, state_next=%h",
                         expected_base_rate, expected_pg_rst, expected_ssg_inv_out, expected_state_next);
                $display("  Got:      base_rate=%h, pg_rst=%b, ssg_inv_out=%b, state_next=%h",
                         base_rate, pg_rst, ssg_inv_out, state_next);
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
