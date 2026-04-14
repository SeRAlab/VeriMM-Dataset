`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] in;
    reg rst;
    reg writeData;
    wire [4:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .rst(rst),
        .writeData(writeData),
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
            writeData = 0;
            in = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Reset", test_num);
            reset_dut();

            #1;


            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Writing 5'h1A to register", test_num);
            reset_dut();

            @(negedge clk);
            rst = 0;
            writeData = 1;
            in = 5'h1A;

            @(posedge clk);
            #2;
            #1;

            check_outputs(5'h1A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Hold (writeData=0)", test_num);
            reset_dut();


            @(negedge clk);
            writeData = 1;
            in = 5'h0F;
            @(posedge clk);


            @(negedge clk);
            writeData = 0;
            in = 5'h15;
            @(posedge clk);

            #2;
            #1;

            check_outputs(5'h0F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset priority over writeData", test_num);
            reset_dut();

            @(negedge clk);
            rst = 1;
            writeData = 1;
            in = 5'h1F;

            @(posedge clk);
            #2;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Writing 5'b11111", test_num);
            reset_dut();

            @(negedge clk);
            writeData = 1;
            in = 5'b11111;

            @(posedge clk);
            #2;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Consecutive writes", test_num);
            reset_dut();

            @(negedge clk);
            writeData = 1;
            in = 5'h05;
            @(posedge clk);

            @(negedge clk);
            in = 5'h12;
            @(posedge clk);

            #2;
            #1;

            check_outputs(5'h12);
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
        input [4:0] expected_out;
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
        $dumpvars(0,clk, in, rst, writeData, out);
    end

endmodule
