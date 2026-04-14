`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] x;
    reg [7:0] y;
    wire [15:0] prod;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .x(x),
        .y(y),
        .prod(prod),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1 reset = 0;

            @(posedge clk);
        end
        endtask
    task wait_for_ready;

        integer timeout;
        begin
            timeout = 0;
            while (!ready && timeout < 32) begin
                @(posedge clk);
                timeout = timeout + 1;
            end
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 0 * 0", test_num);
            x = 8'd0; y = 8'd0;
            reset_dut();
            wait_for_ready();
            #1;

            check_outputs(16'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 15 * 0", test_num);
            x = 8'd15; y = 8'd0;
            reset_dut();
            wait_for_ready();
            #1;

            check_outputs(16'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 1 * 25", test_num);
            x = 8'd1; y = 8'd25;
            reset_dut();
            wait_for_ready();
            #1;

            check_outputs(16'd25, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 123 * 1", test_num);
            x = 8'd123; y = 8'd1;
            reset_dut();
            wait_for_ready();
            #1;

            check_outputs(16'd123, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 12 * 11", test_num);
            x = 8'd12; y = 8'd11;
            reset_dut();
            wait_for_ready();
            #1;

            check_outputs(16'd132, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 16 * 8", test_num);
            x = 8'd16; y = 8'd8;
            reset_dut();
            wait_for_ready();
            #1;

            check_outputs(16'd128, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 255 * 255", test_num);
            x = 8'hFF; y = 8'hFF;
            reset_dut();
            wait_for_ready();
            #1;

            check_outputs(16'd65025, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 0xAA * 0x55", test_num);
            x = 8'hAA; y = 8'h55;
            reset_dut();
            wait_for_ready();
            #1;

            check_outputs(16'h3872, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 13 * 17", test_num);
            x = 8'd13; y = 8'd17;
            reset_dut();
            wait_for_ready();
            #1;

            check_outputs(16'd221, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 200 * 50", test_num);
            x = 8'd200; y = 8'd50;
            reset_dut();
            wait_for_ready();
            #1;

            check_outputs(16'd10000, 1'b1);
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
        input [15:0] expected_prod;
        input expected_ready;
        begin
            if (expected_prod === (expected_prod ^ prod ^ expected_prod) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: prod=%h, ready=%b",
                         prod, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: prod=%h, ready=%b",
                         expected_prod, expected_ready);
                $display("  Got:      prod=%h, ready=%b",
                         prod, ready);
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
        $dumpvars(0,clk, reset, x, y, prod, ready);
    end

endmodule
