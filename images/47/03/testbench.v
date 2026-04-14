`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ym_p1;
    reg ym_sh1;
    reg ym_sh2;
    reg ym_so;
    wire [15:0] left;
    wire [15:0] left_exp;
    wire [15:0] right;
    wire [15:0] right_exp;
    wire update_left;
    wire update_right;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ym_p1(ym_p1),
        .ym_sh1(ym_sh1),
        .ym_sh2(ym_sh2),
        .ym_so(ym_so),
        .left(left),
        .left_exp(left_exp),
        .right(right),
        .right_exp(right_exp),
        .update_left(update_left),
        .update_right(update_right)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ym_p1 = 0;
            ym_sh1 = 0;
            ym_sh2 = 0;
            ym_so = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task shift_data;

        input [15:0] data;
        input integer channel;
        integer i;
        begin
            @(posedge clk);
            if (channel == 1) ym_sh1 = 1; else ym_sh2 = 1;

            for (i = 15; i >= 0; i = i - 1) begin
                ym_so = data[i];
                @(posedge clk);
            end

            ym_sh1 = 0;
            ym_sh2 = 0;
            ym_so = 0;


            ym_p1 = 1;
            @(posedge clk);
            ym_p1 = 0;


            repeat(3) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Loading Left Channel with 0xACE0", test_num);
            reset_dut();
            shift_data(16'hACE0, 1);


            #1;



            check_outputs(16'hACE0, 16'hACE0, 16'h0000, 16'h0000, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Loading Right Channel with 0x1234", test_num);
            reset_dut();
            shift_data(16'h1234, 2);
            #1;

            check_outputs(16'h0000, 16'h0000, 16'h1234, 16'h1234, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Loading Left 0xFFFF and Right 0x5555", test_num);
            reset_dut();
            shift_data(16'hFFFF, 1);
            shift_data(16'h5555, 2);

            #1;


            check_outputs(16'hFFFF, 16'hFFFF, 16'h5555, 16'h5555, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verify no update without sh signals", test_num);
            reset_dut();

            for (i = 0; i < 16; i = i + 1) begin
                ym_so = ~ym_so;
                @(posedge clk);
            end
            #1;

            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000, 1'b0, 1'b0);
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
        input [15:0] expected_left;
        input [15:0] expected_left_exp;
        input [15:0] expected_right;
        input [15:0] expected_right_exp;
        input expected_update_left;
        input expected_update_right;
        begin
            if (expected_left === (expected_left ^ left ^ expected_left) &&
                expected_left_exp === (expected_left_exp ^ left_exp ^ expected_left_exp) &&
                expected_right === (expected_right ^ right ^ expected_right) &&
                expected_right_exp === (expected_right_exp ^ right_exp ^ expected_right_exp) &&
                expected_update_left === (expected_update_left ^ update_left ^ expected_update_left) &&
                expected_update_right === (expected_update_right ^ update_right ^ expected_update_right)) begin
                $display("PASS");
                $display("  Outputs: left=%h, left_exp=%h, right=%h, right_exp=%h, update_left=%b, update_right=%b",
                         left, left_exp, right, right_exp, update_left, update_right);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: left=%h, left_exp=%h, right=%h, right_exp=%h, update_left=%b, update_right=%b",
                         expected_left, expected_left_exp, expected_right, expected_right_exp, expected_update_left, expected_update_right);
                $display("  Got:      left=%h, left_exp=%h, right=%h, right_exp=%h, update_left=%b, update_right=%b",
                         left, left_exp, right, right_exp, update_left, update_right);
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
        $dumpvars(0,clk, ym_p1, ym_sh1, ym_sh2, ym_so, left, left_exp, right, right_exp, update_left, update_right);
    end

endmodule
