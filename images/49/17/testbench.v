`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] bus_in;
    reg clk;
    reg enable;
    reg jump;
    reg out_enable;
    reg rst;
    wire [3:0] bus_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bus_in(bus_in),
        .clk(clk),
        .enable(enable),
        .jump(jump),
        .out_enable(out_enable),
        .rst(rst),
        .bus_out(bus_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        enable = 0;
        jump = 0;
        out_enable = 0;
        bus_in = 4'b0000;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset behavior", test_num);
        reset_dut();
        out_enable = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Jump loading", test_num);
        reset_dut();
        out_enable = 1;
        bus_in = 4'hA;
        jump = 1;
        @(posedge clk);
        #1;
        jump = 0;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Counting enabled", test_num);
        reset_dut();
        out_enable = 1;
        enable = 1;
        repeat (3) @(posedge clk);
        #1;
        enable = 0;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable inhibition", test_num);
        reset_dut();
        out_enable = 1;

        enable = 1;
        @(posedge clk);

        #1 enable = 0;
        repeat (2) @(posedge clk);
        #1;
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Roll-over 15 to 0", test_num);
        reset_dut();
        out_enable = 1;

        bus_in = 4'hF;
        jump = 1;
        @(posedge clk);
        #1 jump = 0;

        enable = 1;
        @(posedge clk);
        #1 enable = 0;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Jump priority over Increment", test_num);
        reset_dut();
        out_enable = 1;

        bus_in = 4'h5;
        jump = 1;
        enable = 1;
        @(posedge clk);
        #1;
        jump = 0;
        enable = 0;

        #1;


        check_outputs(4'h5);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sequential Jump and Increment", test_num);
        reset_dut();
        out_enable = 1;

        bus_in = 4'h2;
        jump = 1;
        @(posedge clk);
        #1 jump = 0;

        enable = 1;
        repeat (2) @(posedge clk);
        #1 enable = 0;
        #1;

        check_outputs(4'h4);
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
        input [3:0] expected_bus_out;
        begin
            if (expected_bus_out === (expected_bus_out ^ bus_out ^ expected_bus_out)) begin
                $display("PASS");
                $display("  Outputs: bus_out=%h",
                         bus_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bus_out=%h",
                         expected_bus_out);
                $display("  Got:      bus_out=%h",
                         bus_out);
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
        $dumpvars(0,bus_in, clk, enable, jump, out_enable, rst, bus_out);
    end

endmodule
