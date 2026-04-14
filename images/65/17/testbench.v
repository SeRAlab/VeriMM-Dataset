`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ck;
    reg [63:0] i_a;
    reg [63:0] i_b;
    reg [6:0] i_htId;
    reg i_vld;
    wire [6:0] o_htId;
    wire [63:0] o_res;
    wire o_vld;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ck(ck),
        .i_a(i_a),
        .i_b(i_b),
        .i_htId(i_htId),
        .i_vld(i_vld),
        .o_htId(o_htId),
        .o_res(o_res),
        .o_vld(o_vld)
    );

    // Clock generation (10ns period)
    initial begin
        ck = 0;
        forever #5 ck = ~ck;
    end

        task reset_dut;

    begin
        i_a <= 64'd0;
        i_b <= 64'd0;
        i_htId <= 7'd0;
        i_vld <= 1'b0;
        repeat (10) @(posedge ck);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        @(posedge ck);
        i_a <= 64'd100;
        i_b <= 64'd200;
        i_htId <= 7'h01;
        i_vld <= 1'b1;
        @(posedge ck);
        i_vld <= 1'b0;
        i_a <= 64'd0;
        i_b <= 64'd0;
        repeat(5) @(posedge ck);
        #1;

        check_outputs(7'h01, 64'd300, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        @(posedge ck);
        i_a <= 64'hFFFFFFFFFFFFFFFF;
        i_b <= 64'h0000000000000001;
        i_htId <= 7'h0F;
        i_vld <= 1'b1;
        @(posedge ck);
        i_vld <= 1'b0;
        repeat(5) @(posedge ck);

        #1;


        check_outputs(7'h0F, 64'h0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        @(posedge ck);
        i_a <= 64'h0;
        i_b <= 64'h0;
        i_htId <= 7'h7F;
        i_vld <= 1'b1;
        @(posedge ck);
        i_vld <= 1'b0;
        repeat(5) @(posedge ck);
        #1;

        check_outputs(7'h7F, 64'h0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        @(posedge ck);
        i_a <= 64'd50;
        i_b <= 64'd50;
        i_htId <= 7'h22;
        i_vld <= 1'b0;
        @(posedge ck);
        repeat(5) @(posedge ck);

        #1;


        check_outputs(o_htId, o_res, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        @(posedge ck);

        i_a <= 64'd1; i_b <= 64'd1; i_htId <= 7'h10; i_vld <= 1'b1;
        @(posedge ck);

        i_a <= 64'd2; i_b <= 64'd2; i_htId <= 7'h11; i_vld <= 1'b1;
        @(posedge ck);

        i_a <= 64'd3; i_b <= 64'd3; i_htId <= 7'h12; i_vld <= 1'b1;
        @(posedge ck);

        i_a <= 64'd4; i_b <= 64'd4; i_htId <= 7'h13; i_vld <= 1'b1;
        @(posedge ck);

        i_a <= 64'd5; i_b <= 64'd5; i_htId <= 7'h14; i_vld <= 1'b1;
        @(posedge ck);
        i_vld <= 1'b0;


        repeat(4) @(posedge ck);
        #1;

        check_outputs(7'h14, 64'd10, 1'b1);
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
        input [6:0] expected_o_htId;
        input [63:0] expected_o_res;
        input expected_o_vld;
        begin
            if (expected_o_htId === (expected_o_htId ^ o_htId ^ expected_o_htId) &&
                expected_o_res === (expected_o_res ^ o_res ^ expected_o_res) &&
                expected_o_vld === (expected_o_vld ^ o_vld ^ expected_o_vld)) begin
                $display("PASS");
                $display("  Outputs: o_htId=%h, o_res=%h, o_vld=%b",
                         o_htId, o_res, o_vld);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_htId=%h, o_res=%h, o_vld=%b",
                         expected_o_htId, expected_o_res, expected_o_vld);
                $display("  Got:      o_htId=%h, o_res=%h, o_vld=%b",
                         o_htId, o_res, o_vld);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,ck, i_a, i_b, i_htId, i_vld, o_htId, o_res, o_vld);
    end

endmodule
