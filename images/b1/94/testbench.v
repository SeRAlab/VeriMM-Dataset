`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] addr;
    reg clk;
    reg [7:0] data_in;
    reg en;
    reg rd;
    reg rst;
    reg wr;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .en(en),
        .rd(rd),
        .rst(rst),
        .wr(wr),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            wr = 0;
            rd = 0;
            addr = 0;
            data_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset functional check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            @(posedge clk);
            en = 1;
            wr = 1;
            rd = 0;
            addr = 10'h0A5;
            data_in = 8'h55;

            @(posedge clk);

            wr = 0;
            rd = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Address Isolation", test_num);
            reset_dut();


            @(posedge clk);
            en = 1; wr = 1; addr = 10'h100; data_in = 8'hAA;
            @(posedge clk);

            addr = 10'h200; data_in = 8'hBB;
            @(posedge clk);


            wr = 0; rd = 1; addr = 10'h100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Signal Control", test_num);
            reset_dut();


            @(posedge clk);
            en = 0; wr = 1; addr = 10'h050; data_in = 8'hFF;
            @(posedge clk);


            en = 1; wr = 0; rd = 1; addr = 10'h050;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address Check (0x3FF)", test_num);
            reset_dut();


            @(posedge clk);
            en = 1; wr = 1; addr = 10'h3FF; data_in = 8'hC3;
            @(posedge clk);


            wr = 0; rd = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hC3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset priority over memory output", test_num);
            reset_dut();


            @(posedge clk);
            en = 1; wr = 1; addr = 10'h001; data_in = 8'h77;
            @(posedge clk);
            wr = 0; rd = 1;
            @(posedge clk);
            #1;


            rst = 1;
            @(posedge clk);
            #1 rst = 0;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,addr, clk, data_in, en, rd, rst, wr, data_out);
    end

endmodule
