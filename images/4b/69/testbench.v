`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] in_signal;
    reg reset;
    wire [15:0] out_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_signal(in_signal),
        .reset(reset),
        .out_signal(out_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in_signal = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Zeros", test_num);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                in_signal = 32'h0;
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Monotonic Increase", test_num);
            reset_dut();
            for (i = 1; i <= 8; i = i + 1) begin
                in_signal = i;
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(16'd8);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Monotonic Decrease", test_num);
            reset_dut();
            for (i = 8; i >= 1; i = i - 1) begin
                in_signal = i;
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(16'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Peak in Middle", test_num);
            reset_dut();

            in_signal = 32'd0;   @(posedge clk); #1;
            in_signal = 32'd0;   @(posedge clk); #1;
            in_signal = 32'd0;   @(posedge clk); #1;
            in_signal = 32'd0;   @(posedge clk); #1;
            in_signal = 32'd500; @(posedge clk); #1;
            in_signal = 32'd0;   @(posedge clk); #1;
            in_signal = 32'd0;   @(posedge clk); #1;
            in_signal = 32'd0;   @(posedge clk); #1;
            #1;

            check_outputs(16'd500);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sliding Window Shift-out", test_num);
            reset_dut();

            in_signal = 32'hAAAA; @(posedge clk); #1;

            for (i = 0; i < 7; i = i + 1) begin
                in_signal = 32'h1111; @(posedge clk); #1;
            end


            in_signal = 32'h2222; @(posedge clk); #1;

            #1;


            check_outputs(16'h2222);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Ignore High 16 Bits", test_num);
            reset_dut();

            in_signal = 32'hFFFF0005; @(posedge clk); #1;

            in_signal = 32'h00000010; @(posedge clk); #1;

            repeat(6) @(posedge clk); #1;

            #1;


            check_outputs(16'h0010);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Maximum 16-bit Value", test_num);
            reset_dut();
            in_signal = 32'h0000FFFF; @(posedge clk); #1;
            repeat(7) begin
                in_signal = 32'h0000EEEE; @(posedge clk); #1;
            end
            #1;

            check_outputs(16'hFFFF);
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
        input [15:0] expected_out_signal;
        begin
            if (expected_out_signal === (expected_out_signal ^ out_signal ^ expected_out_signal)) begin
                $display("PASS");
                $display("  Outputs: out_signal=%h",
                         out_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_signal=%h",
                         expected_out_signal);
                $display("  Got:      out_signal=%h",
                         out_signal);
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
        $dumpvars(0,clk, in_signal, reset, out_signal);
    end

endmodule
