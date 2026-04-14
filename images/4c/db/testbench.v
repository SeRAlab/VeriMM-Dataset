`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] i_a_in;
    reg [31:0] i_b_in;
    reg i_clk;
    reg i_execute;
    reg [1:0] i_function;
    reg i_rst;
    wire o_done;
    wire [1:0] o_flags;
    wire [31:0] o_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_a_in(i_a_in),
        .i_b_in(i_b_in),
        .i_clk(i_clk),
        .i_execute(i_execute),
        .i_function(i_function),
        .i_rst(i_rst),
        .o_done(o_done),
        .o_flags(o_flags),
        .o_out(o_out)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        begin
            i_rst = 1;
            i_a_in = 0;
            i_b_in = 0;
            i_function = 0;
            i_execute = 0;
            repeat(2) @(posedge i_clk);
            #1 i_rst = 0;
            @(posedge i_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 5 * 10 = 50", test_num);
            i_a_in = 32'd5;
            i_b_in = 32'd10;
            i_execute = 1;
            i_function = 2'b00;
            @(posedge i_clk);
            #1 i_execute = 0;
            repeat(10) @(posedge i_clk);
            #1;

            check_outputs(1'b1, 2'b00, 32'd50);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 10 * -2 = -20", test_num);
            i_a_in = 32'd10;
            i_b_in = 32'hFFFFFFFE;
            i_execute = 1;
            i_function = 2'b00;
            @(posedge i_clk);
            #1 i_execute = 0;
            repeat(10) @(posedge i_clk);
            #1;

            check_outputs(1'b1, 2'b10, 32'hFFFFFFEC);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 0 * 500 = 0", test_num);
            i_a_in = 32'd0;
            i_b_in = 32'd500;
            i_execute = 1;
            i_function = 2'b00;
            @(posedge i_clk);
            #1 i_execute = 0;
            repeat(10) @(posedge i_clk);
            #1;

            check_outputs(1'b1, 2'b01, 32'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 10 * 5 + 15 = 65", test_num);
            i_a_in = 32'd10;
            i_b_in = 32'd5;
            i_execute = 1;
            i_function = 2'b00;
            @(posedge i_clk);
            #1 i_execute = 0;
            repeat(2) @(posedge i_clk);

            i_a_in = 32'd15;
            i_function = 2'b01;
            @(posedge i_clk);
            #1 i_function = 0;
            repeat(5) @(posedge i_clk);
            #1;

            check_outputs(1'b1, 2'b00, 32'd65);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 20 * 5 + (-100) = 0", test_num);
            i_a_in = 32'd20;
            i_b_in = 32'd5;
            i_execute = 1;
            @(posedge i_clk);
            #1 i_execute = 0;
            repeat(2) @(posedge i_clk);

            i_a_in = 32'hFFFFFF9C;
            i_function = 2'b01;
            @(posedge i_clk);
            #1 i_function = 0;
            repeat(5) @(posedge i_clk);
            #1;

            check_outputs(1'b1, 2'b01, 32'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 0x7FFFFFFF * 1 + 1 = 0x80000000 (Negative)", test_num);
            i_a_in = 32'h7FFFFFFF;
            i_b_in = 32'd1;
            i_execute = 1;
            @(posedge i_clk);
            #1 i_execute = 0;
            repeat(2) @(posedge i_clk);

            i_a_in = 32'd1;
            i_function = 2'b01;
            @(posedge i_clk);
            #1 i_function = 0;
            repeat(5) @(posedge i_clk);
            #1;

            check_outputs(1'b1, 2'b10, 32'h80000000);
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
        input expected_o_done;
        input [1:0] expected_o_flags;
        input [31:0] expected_o_out;
        begin
            if (expected_o_done === (expected_o_done ^ o_done ^ expected_o_done) &&
                expected_o_flags === (expected_o_flags ^ o_flags ^ expected_o_flags) &&
                expected_o_out === (expected_o_out ^ o_out ^ expected_o_out)) begin
                $display("PASS");
                $display("  Outputs: o_done=%b, o_flags=%h, o_out=%h",
                         o_done, o_flags, o_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_done=%b, o_flags=%h, o_out=%h",
                         expected_o_done, expected_o_flags, expected_o_out);
                $display("  Got:      o_done=%b, o_flags=%h, o_out=%h",
                         o_done, o_flags, o_out);
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
        $dumpvars(0,i_a_in, i_b_in, i_clk, i_execute, i_function, i_rst, o_done, o_flags, o_out);
    end

endmodule
