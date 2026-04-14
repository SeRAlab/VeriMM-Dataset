`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg [7:0] din;
    reg en;
    reg load;
    reg rst;
    reg up;
    wire [4:0] op;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr(clr),
        .din(din),
        .en(en),
        .load(load),
        .rst(rst),
        .up(up),
        .op(op)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clr = 1;
            rst = 0;
            en = 0;
            load = 0;
            up = 0;
            din = 8'h00;
            @(posedge clk);
            #1 clr = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();

            load = 1;
            din = 8'h1F;
            @(posedge clk);
            #1 load = 0;

            clr = 1;
            @(posedge clk);
            #1 clr = 0;
            $display("Testcase001: Clear Operation");
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            rst = 1;
            din = 8'h0A;
            @(posedge clk);
            #1 rst = 0;
            $display("Testcase002: Reset (Load Initial) Operation");
            #1;

            check_outputs(5'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            load = 1;
            din = 8'h15;
            @(posedge clk);
            #1 load = 0;
            $display("Testcase003: Load Operation");
            #1;

            check_outputs(5'd21);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            en = 1;
            up = 1;
            repeat(5) @(posedge clk);
            #1;
            $display("Testcase004: Increment Operation (5 cycles)");
            #1;

            check_outputs(5'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();

            load = 1;
            din = 8'd10;
            @(posedge clk);
            #1 load = 0;

            en = 1;
            up = 0;
            repeat(3) @(posedge clk);
            #1;
            $display("Testcase005: Decrement Operation (10 down to 7)");
            #1;

            check_outputs(5'd7);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            load = 1;
            din = 8'd15;
            @(posedge clk);
            #1 load = 0;
            en = 0;
            up = 1;
            repeat(3) @(posedge clk);
            #1;
            $display("Testcase006: Enable Signal (Counter Should Hold at 15)");
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            load = 1;
            din = 8'd31;
            @(posedge clk);
            #1 load = 0;
            en = 1;
            up = 1;
            @(posedge clk);
            #1;
            $display("Testcase007: Rollover (31 to 0)");
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            en = 1;
            up = 0;
            @(posedge clk);
            #1;
            $display("Testcase008: Underflow (0 to 31)");
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            clr = 1;
            load = 1;
            din = 8'hFF;
            @(posedge clk);
            #1;
            $display("Testcase009: Priority Test (Clear vs Load)");
            #1;

            check_outputs(5'd0);
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
        input [4:0] expected_op;
        begin
            if (expected_op === (expected_op ^ op ^ expected_op)) begin
                $display("PASS");
                $display("  Outputs: op=%h",
                         op);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: op=%h",
                         expected_op);
                $display("  Got:      op=%h",
                         op);
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
        $dumpvars(0,clk, clr, din, en, load, rst, up, op);
    end

endmodule
