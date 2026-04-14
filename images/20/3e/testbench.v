`timescale 1ns/1ps

module ecc_point_doubling_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [31:0] x_in;
    reg [31:0] y_in;
    wire [31:0] x_out;
    wire [31:0] y_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ecc_point_doubling dut (
        .clk(clk),
        .rst(rst),
        .x_in(x_in),
        .y_in(y_in),
        .x_out(x_out),
        .y_out(y_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x_in = 0;
            y_in = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Doubling point (0, 1)", test_num);
            reset_dut();
            x_in = 32'd0;
            y_in = 32'd1;

            repeat (20) @(posedge clk);
            #1;

            check_outputs(32'd13, 32'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Doubling point (6, 6)", test_num);
            reset_dut();
            x_in = 32'd6;
            y_in = 32'd6;
            repeat (20) @(posedge clk);
            #1;

            check_outputs(32'd9, 32'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Doubling point (13, 1)", test_num);
            reset_dut();
            x_in = 32'd13;
            y_in = 32'd1;
            repeat (20) @(posedge clk);
            #1;

            check_outputs(32'd9, 32'd12);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Doubling point (10, 5)", test_num);
            reset_dut();
            x_in = 32'd10;
            y_in = 32'd5;
            repeat (20) @(posedge clk);
            #1;

            check_outputs(32'd10, 32'd12);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Doubling point (7, 11)", test_num);
            reset_dut();
            x_in = 32'd7;
            y_in = 32'd11;
            repeat (20) @(posedge clk);
            #1;

            check_outputs(32'd4, 32'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ecc_point_doubling Testbench");
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
        input [31:0] expected_x_out;
        input [31:0] expected_y_out;
        begin
            if (expected_x_out === (expected_x_out ^ x_out ^ expected_x_out) &&
                expected_y_out === (expected_y_out ^ y_out ^ expected_y_out)) begin
                $display("PASS");
                $display("  Outputs: x_out=%h, y_out=%h",
                         x_out, y_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_out=%h, y_out=%h",
                         expected_x_out, expected_y_out);
                $display("  Got:      x_out=%h, y_out=%h",
                         x_out, y_out);
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
        $dumpvars(0,clk, rst, x_in, y_in, x_out, y_out);
    end

endmodule
