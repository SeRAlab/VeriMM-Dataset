`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg out_ack_reset_0;
    reg out_ack_reset_1;
    reg out_ack_reset_2;
    reg out_ack_reset_3;
    reg out_ack_reset_4;
    reg out_ack_reset_5;
    reg packet_drop_signal_0;
    reg packet_drop_signal_1;
    reg packet_drop_signal_2;
    reg packet_drop_signal_3;
    reg packet_drop_signal_4;
    reg packet_drop_signal_5;
    reg [2:0] sel;
    wire out_ack_reset_out;
    wire packet_drop_signal_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .out_ack_reset_0(out_ack_reset_0),
        .out_ack_reset_1(out_ack_reset_1),
        .out_ack_reset_2(out_ack_reset_2),
        .out_ack_reset_3(out_ack_reset_3),
        .out_ack_reset_4(out_ack_reset_4),
        .out_ack_reset_5(out_ack_reset_5),
        .packet_drop_signal_0(packet_drop_signal_0),
        .packet_drop_signal_1(packet_drop_signal_1),
        .packet_drop_signal_2(packet_drop_signal_2),
        .packet_drop_signal_3(packet_drop_signal_3),
        .packet_drop_signal_4(packet_drop_signal_4),
        .packet_drop_signal_5(packet_drop_signal_5),
        .sel(sel),
        .out_ack_reset_out(out_ack_reset_out),
        .packet_drop_signal_out(packet_drop_signal_out)
    );
    task clear_inputs;

    begin
        out_ack_reset_0 = 0; packet_drop_signal_0 = 0;
        out_ack_reset_1 = 0; packet_drop_signal_1 = 0;
        out_ack_reset_2 = 0; packet_drop_signal_2 = 0;
        out_ack_reset_3 = 0; packet_drop_signal_3 = 0;
        out_ack_reset_4 = 0; packet_drop_signal_4 = 0;
        out_ack_reset_5 = 0; packet_drop_signal_5 = 0;
        sel = 3'b000;
    end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select input pair 0 (sel=0)", test_num);
        clear_inputs();
        out_ack_reset_0 = 1;
        packet_drop_signal_0 = 0;
        sel = 3'd0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select input pair 1 (sel=1)", test_num);
        clear_inputs();
        out_ack_reset_1 = 0;
        packet_drop_signal_1 = 1;
        sel = 3'd1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select input pair 2 (sel=2)", test_num);
        clear_inputs();
        out_ack_reset_2 = 1;
        packet_drop_signal_2 = 1;
        sel = 3'd2;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select input pair 3 (sel=3)", test_num);
        clear_inputs();
        out_ack_reset_3 = 0;
        packet_drop_signal_3 = 0;
        sel = 3'd3;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select input pair 4 (sel=4)", test_num);
        clear_inputs();
        out_ack_reset_4 = 1;
        packet_drop_signal_4 = 0;
        sel = 3'd4;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select input pair 5 (sel=5)", test_num);
        clear_inputs();
        out_ack_reset_5 = 0;
        packet_drop_signal_5 = 1;
        sel = 3'd5;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Out of range selection (sel=6)", test_num);
        clear_inputs();

        out_ack_reset_0 = 1; packet_drop_signal_0 = 1;
        out_ack_reset_5 = 1; packet_drop_signal_5 = 1;
        sel = 3'd6;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Out of range selection (sel=7)", test_num);
        clear_inputs();

        out_ack_reset_0 = 1; packet_drop_signal_0 = 1;
        out_ack_reset_5 = 1; packet_drop_signal_5 = 1;
        sel = 3'd7;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Interference Check (Verify only selected channel passes)", test_num);

        out_ack_reset_0 = 0; packet_drop_signal_0 = 1;
        out_ack_reset_1 = 0; packet_drop_signal_1 = 1;
        out_ack_reset_2 = 1; packet_drop_signal_2 = 0;
        out_ack_reset_3 = 0; packet_drop_signal_3 = 1;
        out_ack_reset_4 = 0; packet_drop_signal_4 = 1;
        out_ack_reset_5 = 0; packet_drop_signal_5 = 1;
        sel = 3'd2;
        #1;

        check_outputs(1'b1, 1'b0);
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
        input expected_out_ack_reset_out;
        input expected_packet_drop_signal_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_ack_reset_out === (expected_out_ack_reset_out ^ out_ack_reset_out ^ expected_out_ack_reset_out) &&
                expected_packet_drop_signal_out === (expected_packet_drop_signal_out ^ packet_drop_signal_out ^ expected_packet_drop_signal_out)) begin
                $display("PASS");
                $display("  Outputs: out_ack_reset_out=%b, packet_drop_signal_out=%b",
                         out_ack_reset_out, packet_drop_signal_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_ack_reset_out=%b, packet_drop_signal_out=%b",
                         expected_out_ack_reset_out, expected_packet_drop_signal_out);
                $display("  Got:      out_ack_reset_out=%b, packet_drop_signal_out=%b",
                         out_ack_reset_out, packet_drop_signal_out);
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
