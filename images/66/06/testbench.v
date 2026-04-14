`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset_n;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .reset_n(reset_n),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            data_in = 0;
            repeat(2) @(posedge clk);
            #1;
            reset_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            data_in = 8'd5;
            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Test %0d: Input < 10 (data_in=5)", test_num);
            #1;

            check_outputs(8'd5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            data_in = 8'd9;
            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Test %0d: Input = 9 (Boundary < 10)", test_num);
            #1;

            check_outputs(8'd9);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            data_in = 8'd10;
            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Test %0d: Input = 10 (Boundary 10-50)", test_num);
            #1;

            check_outputs(8'd20);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            data_in = 8'd25;
            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Test %0d: Input 10-50 (data_in=25)", test_num);
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            data_in = 8'd50;
            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Test %0d: Input = 50 (Boundary 10-50)", test_num);
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            data_in = 8'd51;
            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Test %0d: Input = 51 (Boundary > 50)", test_num);
            #1;

            check_outputs(8'd25);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            data_in = 8'd120;
            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Test %0d: Input > 50 (data_in=120)", test_num);
            #1;

            check_outputs(8'd60);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            data_in = 8'd255;
            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Test %0d: Maximum Input (data_in=255)", test_num);
            #1;

            check_outputs(8'd127);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            data_in = 8'd0;
            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Test %0d: Minimum Input (data_in=0)", test_num);
            #1;

            check_outputs(8'd0);
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
        $dumpvars(0,clk, data_in, reset_n, data_out);
    end

endmodule
