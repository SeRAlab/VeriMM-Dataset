`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [99:0] in;
    reg rst;
    wire [99:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
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
            in = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Reset and verify zero shift", test_num);
            reset_dut();

            in = 100'hABCDE;
            #2;
            #1;

            check_outputs(100'hABCDE);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Shift by 1 bit (LSB=1 in SR)", test_num);
            reset_dut();

            in = IN_MSB_SET;
            @(posedge clk);

            #1;
            in = 100'h1;
            #2;
            #1;

            check_outputs(100'h1 << 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Shift by 2 bits (SR=2)", test_num);
            reset_dut();

            in = IN_MSB_SET; @(posedge clk);
            #1;

            in = 100'h0; @(posedge clk);
            #1;
            in = 100'hF;
            #2;
            #1;

            check_outputs(100'hF << 2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Shift by 5 bits (SR sequence 00101)", test_num);
            reset_dut();

            in = 0;          @(posedge clk);
            in = 0;          @(posedge clk);
            in = IN_MSB_SET; @(posedge clk);
            in = 0;          @(posedge clk);
            in = IN_MSB_SET; @(posedge clk);
            #1;
            in = 100'hFF;
            #2;
            #1;

            check_outputs(100'hFF << 5);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Max shift by 31 bits (SR sequence 11111)", test_num);
            reset_dut();

            in = IN_MSB_SET;
            for (i=0; i<5; i=i+1) begin
                @(posedge clk);
            end
            #1;

            in = 100'h1;
            #2;
            #1;

            check_outputs(100'h1 << 31);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Check large input value with shift", test_num);
            reset_dut();

            in = IN_MSB_SET; @(posedge clk);
            in = 0;          @(posedge clk);
            in = 0;          @(posedge clk);
            #1;

            in = (100'h1 << 98);
            #2;

            #1;


            check_outputs(in << 4);
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
        input [99:0] expected_out;
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
        $dumpvars(0,clk, in, rst, out);
    end

endmodule
