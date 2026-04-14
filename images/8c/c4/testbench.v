`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg [31:0] in;
    reg ld;
    reg [3:0] load_data;
    reg rst;
    wire [35:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en(en),
        .in(in),
        .ld(ld),
        .load_data(load_data),
        .rst(rst),
        .out(out)
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
            ld = 0;
            in = 0;
            load_data = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset check with zero input", test_num);
            reset_dut();
            in = 0;
            #1 #1;
 check_outputs(36'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Positive input absolute value", test_num);
            reset_dut();
            in = 32'sd12345;
            #1 #1;
 check_outputs(36'd12345);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Negative input absolute value", test_num);
            reset_dut();
            in = -32'sd500;
            #1 #1;
 check_outputs(36'd500);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Load counter data", test_num);
            reset_dut();
            in = 32'sd1000;
            load_data = 4'd12;
            ld = 1;
            @(posedge clk);
            #1 ld = 0;
            #1;

            check_outputs(36'd1012);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Enable counter for multiple cycles", test_num);
            reset_dut();
            in = 32'sd10;
            en = 1;
            repeat(5) @(posedge clk);
            #1 en = 0;

            #1;


            check_outputs(36'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Counter overflow (4-bit)", test_num);
            reset_dut();
            in = 32'sd0;
            load_data = 4'd14;
            ld = 1;
            @(posedge clk);
            #1 ld = 0;
            en = 1;
            repeat(3) @(posedge clk);
            #1 en = 0;
            #1;

            check_outputs(36'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Absolute value of -2^31", test_num);
            reset_dut();
            in = 32'h8000_0000;
            #1 #1;
 check_outputs(36'h8000_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Load priority over enable", test_num);
            reset_dut();
            in = 32'sd100;
            load_data = 4'd5;
            ld = 1;
            en = 1;
            @(posedge clk);
            #1 ld = 0; en = 0;
            #1;

            check_outputs(36'd105);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %03d: Max counter + Negative input", test_num);
            reset_dut();
            in = -32'sd100;
            load_data = 4'hf;
            ld = 1;
            @(posedge clk);
            #1 ld = 0;
            #1;

            check_outputs(36'd115);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %03d: Input change without counter change", test_num);
            reset_dut();
            en = 1;
            repeat(3) @(posedge clk);
            #1 en = 0;
            in = 32'sd50;
            @(posedge clk);
            #1 #1;
 check_outputs(36'd53);
            in = -32'sd20;
            @(posedge clk);
            #1 #1;
 check_outputs(36'd23);
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
        input [35:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, en, in, ld, load_data, rst, out);
    end

endmodule
