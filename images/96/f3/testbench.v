`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    wire [15:0] data_out;
    wire hs_de;
    wire vs_de;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .data_out(data_out),
        .hs_de(hs_de),
        .vs_de(vs_de)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in = 16'h0;

            repeat(5) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Input Stability", test_num);
            reset_dut();
            data_in = 16'h0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Data Propagation", test_num);
            reset_dut();
            data_in = 16'hA5A5;
            @(posedge clk);
            data_in = 16'h0000;


            repeat(1) @(posedge clk);
            #1;
            #1;

            check_outputs(16'hA5A5, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Continuous Data Stream", test_num);
            reset_dut();
            data_in = 16'h1111; @(posedge clk);
            data_in = 16'h2222; @(posedge clk);
            data_in = 16'h3333; @(posedge clk);
            data_in = 16'h4444; @(posedge clk);
            #1;

            #1;


            check_outputs(16'h4444, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Values", test_num);
            reset_dut();
            data_in = 16'hFFFF;
            @(posedge clk);
            data_in = 16'h0000;
            repeat(1) @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Pattern", test_num);
            reset_dut();
            data_in = 16'hAAAA; @(posedge clk);
            data_in = 16'h5555; @(posedge clk);
            #1;
            #1;

            check_outputs(16'h5555, 1'b1, 1'b1);
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
        input [15:0] expected_data_out;
        input expected_hs_de;
        input expected_vs_de;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_hs_de === (expected_hs_de ^ hs_de ^ expected_hs_de) &&
                expected_vs_de === (expected_vs_de ^ vs_de ^ expected_vs_de)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, hs_de=%b, vs_de=%b",
                         data_out, hs_de, vs_de);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, hs_de=%b, vs_de=%b",
                         expected_data_out, expected_hs_de, expected_vs_de);
                $display("  Got:      data_out=%h, hs_de=%b, vs_de=%b",
                         data_out, hs_de, vs_de);
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
        $dumpvars(0,clk, data_in, data_out, hs_de, vs_de);
    end

endmodule
