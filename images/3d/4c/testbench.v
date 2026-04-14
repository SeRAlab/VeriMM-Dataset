`timescale 1ns/1ps

module fir_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [3:0] x;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fir_filter dut (
        .clk(clk),
        .rst(rst),
        .x(x),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: All Zeros", test_num);
            reset_dut();
            repeat(5) @(posedge clk) x <= 4'd0;
            @(posedge clk); #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Impulse Response (Tail)", test_num);
            reset_dut();
            @(posedge clk) x <= 4'd1;
            repeat(4) @(posedge clk) x <= 4'd0;
            @(posedge clk); #1;
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Max Constant Input", test_num);
            reset_dut();
            repeat(5) @(posedge clk) x <= 4'd15;
            @(posedge clk); #1;
            #1;

            check_outputs(8'hE1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Ramp Input", test_num);
            reset_dut();
            @(posedge clk) x <= 4'd1;
            @(posedge clk) x <= 4'd2;
            @(posedge clk) x <= 4'd3;
            @(posedge clk) x <= 4'd4;
            @(posedge clk) x <= 4'd5;
            @(posedge clk); #1;
            #1;

            check_outputs(8'h23);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Alternating Input", test_num);
            reset_dut();
            @(posedge clk) x <= 4'd10;
            @(posedge clk) x <= 4'd5;
            @(posedge clk) x <= 4'd10;
            @(posedge clk) x <= 4'd5;
            @(posedge clk) x <= 4'd10;
            @(posedge clk); #1;
            #1;

            check_outputs(8'h78);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fir_filter Testbench");
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
        input [7:0] expected_y;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
        $dumpvars(0,clk, rst, x, y);
    end

endmodule
