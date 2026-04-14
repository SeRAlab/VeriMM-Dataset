`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg pipe_ack_i;
    reg pipe_stb_i;
    reg sys_clk;
    reg sys_rst;
    reg [17:0] tex;
    reg [17:0] tey;
    reg [17:0] tsx;
    reg [17:0] tsy;
    reg [11:0] x;
    reg [11:0] y;
    wire busy;
    wire [16:0] diff_x;
    wire diff_x_positive;
    wire [16:0] diff_y;
    wire diff_y_positive;
    wire pipe_ack_o;
    wire pipe_stb_o;
    wire [17:0] tsx_f;
    wire [17:0] tsy_f;
    wire [11:0] x_f;
    wire [11:0] y_f;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pipe_ack_i(pipe_ack_i),
        .pipe_stb_i(pipe_stb_i),
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),
        .tex(tex),
        .tey(tey),
        .tsx(tsx),
        .tsy(tsy),
        .x(x),
        .y(y),
        .busy(busy),
        .diff_x(diff_x),
        .diff_x_positive(diff_x_positive),
        .diff_y(diff_y),
        .diff_y_positive(diff_y_positive),
        .pipe_ack_o(pipe_ack_o),
        .pipe_stb_o(pipe_stb_o),
        .tsx_f(tsx_f),
        .tsy_f(tsy_f),
        .x_f(x_f),
        .y_f(y_f)
    );

    // Clock generation (10ns period)
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end

        task reset_dut;

        begin
            sys_rst = 1;
            pipe_stb_i = 0;
            pipe_ack_i = 0;
            x = 0;
            y = 0;
            tsx = 0;
            tsy = 0;
            tex = 0;
            tey = 0;
            repeat(5) @(posedge sys_clk);
            sys_rst = 0;
            @(posedge sys_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            x = 12'sd100; y = 12'sd200;
            tsx = 18'sd1000; tsy = 18'sd2000;
            tex = 18'sd1500; tey = 18'sd2600;
            pipe_stb_i = 1;
            pipe_ack_i = 1;

            while (!pipe_ack_o) @(posedge sys_clk);
            @(posedge sys_clk);
            pipe_stb_i = 0;

            while (!pipe_stb_o) @(posedge sys_clk);


            #1;



            check_outputs(1'b0, 17'd500, 1'b1, 17'd600, 1'b1, 1'b1, 1'b1, 18'sd1000, 18'sd2000, 12'sd100, 12'sd200);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            x = 12'sd-50; y = 12'sd-60;
            tsx = 18'sd5000; tsy = 18'sd8000;
            tex = 18'sd4000; tey = 18'sd7500;
            pipe_stb_i = 1;
            pipe_ack_i = 1;

            while (!pipe_ack_o) @(posedge sys_clk);
            @(posedge sys_clk);
            pipe_stb_i = 0;

            while (!pipe_stb_o) @(posedge sys_clk);


            #1;



            check_outputs(1'b0, 17'd1000, 1'b0, 17'd500, 1'b0, 1'b1, 1'b1, 18'sd5000, 18'sd8000, 12'sd-50, 12'sd-60);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            x = 12'sd0; y = 12'sd0;
            tsx = 18'sd12345; tsy = 18'sd-12345;
            tex = 18'sd12345; tey = 18'sd-12345;
            pipe_stb_i = 1;
            pipe_ack_i = 1;

            while (!pipe_ack_o) @(posedge sys_clk);
            @(posedge sys_clk);
            pipe_stb_i = 0;

            while (!pipe_stb_o) @(posedge sys_clk);


            #1;



            check_outputs(1'b0, 17'd0, 1'b1, 17'd0, 1'b1, 1'b1, 1'b1, 18'sd12345, 18'sd-12345, 12'sd0, 12'sd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            x = 12'h7FF; y = 12'h800;
            tsx = 18'sd-50000; tsy = 18'sd50000;
            tex = 18'sd50000; tey = 18'sd-50000;
            pipe_stb_i = 1;
            pipe_ack_i = 1;

            while (!pipe_ack_o) @(posedge sys_clk);
            @(posedge sys_clk);
            pipe_stb_i = 0;

            while (!pipe_stb_o) @(posedge sys_clk);



            #1;




            check_outputs(1'b0, 17'd100000, 1'b1, 17'd100000, 1'b0, 1'b1, 1'b1, 18'sd-50000, 18'sd50000, 12'h7FF, 12'h800);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            tsx = 18'sd10; tsy = 18'sd10;
            tex = 18'sd20; tey = 18'sd20;
            pipe_stb_i = 1;
            pipe_ack_i = 0;

            while (!pipe_ack_o) @(posedge sys_clk);
            @(posedge sys_clk);
            pipe_stb_i = 0;


            repeat(5) @(posedge sys_clk);

            if (pipe_stb_o) begin
                pipe_ack_i = 1;
                @(posedge sys_clk);
                #1;

                check_outputs(1'b0, 17'd10, 1'b1, 17'd10, 1'b1, 1'b1, 1'b1, 18'sd10, 18'sd10, 12'sd0, 12'sd0);
            end else begin
                $display("FAIL: Test %0d - pipe_stb_o did not trigger", test_num);
                fail_count = fail_count + 1;
            end
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
        input expected_busy;
        input [16:0] expected_diff_x;
        input expected_diff_x_positive;
        input [16:0] expected_diff_y;
        input expected_diff_y_positive;
        input expected_pipe_ack_o;
        input expected_pipe_stb_o;
        input [17:0] expected_tsx_f;
        input [17:0] expected_tsy_f;
        input [11:0] expected_x_f;
        input [11:0] expected_y_f;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_diff_x === (expected_diff_x ^ diff_x ^ expected_diff_x) &&
                expected_diff_x_positive === (expected_diff_x_positive ^ diff_x_positive ^ expected_diff_x_positive) &&
                expected_diff_y === (expected_diff_y ^ diff_y ^ expected_diff_y) &&
                expected_diff_y_positive === (expected_diff_y_positive ^ diff_y_positive ^ expected_diff_y_positive) &&
                expected_pipe_ack_o === (expected_pipe_ack_o ^ pipe_ack_o ^ expected_pipe_ack_o) &&
                expected_pipe_stb_o === (expected_pipe_stb_o ^ pipe_stb_o ^ expected_pipe_stb_o) &&
                expected_tsx_f === (expected_tsx_f ^ tsx_f ^ expected_tsx_f) &&
                expected_tsy_f === (expected_tsy_f ^ tsy_f ^ expected_tsy_f) &&
                expected_x_f === (expected_x_f ^ x_f ^ expected_x_f) &&
                expected_y_f === (expected_y_f ^ y_f ^ expected_y_f)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, diff_x=%h, diff_x_positive=%b, diff_y=%h, diff_y_positive=%b, pipe_ack_o=%b, pipe_stb_o=%b, tsx_f=%h, tsy_f=%h, x_f=%h, y_f=%h",
                         busy, diff_x, diff_x_positive, diff_y, diff_y_positive, pipe_ack_o, pipe_stb_o, tsx_f, tsy_f, x_f, y_f);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, diff_x=%h, diff_x_positive=%b, diff_y=%h, diff_y_positive=%b, pipe_ack_o=%b, pipe_stb_o=%b, tsx_f=%h, tsy_f=%h, x_f=%h, y_f=%h",
                         expected_busy, expected_diff_x, expected_diff_x_positive, expected_diff_y, expected_diff_y_positive, expected_pipe_ack_o, expected_pipe_stb_o, expected_tsx_f, expected_tsy_f, expected_x_f, expected_y_f);
                $display("  Got:      busy=%b, diff_x=%h, diff_x_positive=%b, diff_y=%h, diff_y_positive=%b, pipe_ack_o=%b, pipe_stb_o=%b, tsx_f=%h, tsy_f=%h, x_f=%h, y_f=%h",
                         busy, diff_x, diff_x_positive, diff_y, diff_y_positive, pipe_ack_o, pipe_stb_o, tsx_f, tsy_f, x_f, y_f);
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
        $dumpvars(0,pipe_ack_i, pipe_stb_i, sys_clk, sys_rst, tex, tey, tsx, tsy, x, y, busy, diff_x, diff_x_positive, diff_y, diff_y_positive, pipe_ack_o, pipe_stb_o, tsx_f, tsy_f, x_f, y_f);
    end

endmodule
