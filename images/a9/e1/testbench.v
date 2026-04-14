`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_v;
    reg [7:0] i_cb;
    reg [7:0] i_cr;
    reg i_state;
    reg [7:0] i_y;
    reg rst_x;
    wire [7:0] o_cb;
    wire [7:0] o_cr;
    wire [7:0] o_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_v(clk_v),
        .i_cb(i_cb),
        .i_cr(i_cr),
        .i_state(i_state),
        .i_y(i_y),
        .rst_x(rst_x),
        .o_cb(o_cb),
        .o_cr(o_cr),
        .o_y(o_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk_v = 0;
        forever #5 clk_v = ~clk_v;
    end

        task reset_dut;

    begin
        rst_x = 0;
        i_cb = 0;
        i_cr = 0;
        i_state = 0;
        i_y = 0;
        repeat(2) @(posedge clk_v);
        #1 rst_x = 1;
        @(posedge clk_v);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Test %0d: Post-Reset Verification", test_num);
        #1;

        check_outputs(8'h00, 8'h00, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        i_y = 8'hA5;
        i_cr = 8'h12;
        i_cb = 8'h34;
        i_state = 0;
        @(posedge clk_v);
        #1;
        $display("Test %0d: State 0 (Bypass/Delay) Check", test_num);
        #1;

        check_outputs(8'h34, 8'h12, 8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();

        i_cr = 8'd50;
        i_cb = 8'd100;
        i_state = 0;
        @(posedge clk_v);

        i_y = 8'h55;
        i_cr = 8'd25;
        i_cb = 8'd30;
        i_state = 1;
        @(posedge clk_v);
        #1;
        $display("Test %0d: State 1 (Summation) Check", test_num);

        #1;


        check_outputs(8'h82, 8'h4B, 8'h55);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        i_y = 8'hAA; @(posedge clk_v);
        i_y = 8'hBB; @(posedge clk_v);
        i_y = 8'hCC; @(posedge clk_v);
        #1;
        $display("Test %0d: Luma Path Sequential Delay Check", test_num);
        #1;

        check_outputs(o_cb, o_cr, 8'hCC);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        i_cr = 8'hFF;
        i_cb = 8'hF0;
        i_state = 0;
        @(posedge clk_v);
        i_cr = 8'h02;
        i_cb = 8'h11;
        i_state = 1;
        @(posedge clk_v);
        #1;
        $display("Test %0d: Chroma Summation Overflow Check", test_num);
        #1;

        check_outputs(8'h01, 8'h01, o_y);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();

        i_cr = 8'd10; i_state = 0;
        @(posedge clk_v);
        i_cr = 8'd10; i_state = 1;
        @(posedge clk_v);

        i_cr = 8'd99; i_state = 0;
        @(posedge clk_v);
        #1;
        $display("Test %0d: State Transition (1 -> 0) Check", test_num);
        #1;

        check_outputs(o_cb, 8'd99, o_y);
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
        input [7:0] expected_o_cb;
        input [7:0] expected_o_cr;
        input [7:0] expected_o_y;
        begin
            if (expected_o_cb === (expected_o_cb ^ o_cb ^ expected_o_cb) &&
                expected_o_cr === (expected_o_cr ^ o_cr ^ expected_o_cr) &&
                expected_o_y === (expected_o_y ^ o_y ^ expected_o_y)) begin
                $display("PASS");
                $display("  Outputs: o_cb=%h, o_cr=%h, o_y=%h",
                         o_cb, o_cr, o_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_cb=%h, o_cr=%h, o_y=%h",
                         expected_o_cb, expected_o_cr, expected_o_y);
                $display("  Got:      o_cb=%h, o_cr=%h, o_y=%h",
                         o_cb, o_cr, o_y);
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
        $dumpvars(0,clk_v, i_cb, i_cr, i_state, i_y, rst_x, o_cb, o_cr, o_y);
    end

endmodule
