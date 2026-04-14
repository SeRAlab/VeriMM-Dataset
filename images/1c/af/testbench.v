`timescale 1ns/1ps

module sample_rate_converter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in_sample;
    reg rst;
    wire [7:0] out_sample;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sample_rate_converter dut (
        .clk(clk),
        .in_sample(in_sample),
        .rst(rst),
        .out_sample(out_sample)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in_sample = 8'h00;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Basic Decimation (2 samples)", test_num);
            reset_dut();
            @(negedge clk) in_sample = 8'h10;
            @(negedge clk) in_sample = 8'h20;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h20);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Extended Sequence (4 samples)", test_num);
            reset_dut();
            @(negedge clk) in_sample = 8'hA1;
            @(negedge clk) in_sample = 8'hB2;
            @(negedge clk) in_sample = 8'hC3;
            @(negedge clk) in_sample = 8'hD4;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hD4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Maximum Values", test_num);
            reset_dut();
            @(negedge clk) in_sample = 8'hFF;
            @(negedge clk) in_sample = 8'hFF;
            @(negedge clk) in_sample = 8'h00;
            @(negedge clk) in_sample = 8'hFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Zero Sequence", test_num);
            reset_dut();
            @(negedge clk) in_sample = 8'h55;
            @(negedge clk) in_sample = 8'h00;
            @(negedge clk) in_sample = 8'hAA;
            @(negedge clk) in_sample = 8'h00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Long Burst", test_num);
            reset_dut();
            @(negedge clk) in_sample = 8'h01;
            @(negedge clk) in_sample = 8'h02;
            @(negedge clk) in_sample = 8'h03;
            @(negedge clk) in_sample = 8'h04;
            @(negedge clk) in_sample = 8'h05;
            @(negedge clk) in_sample = 8'h06;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h06);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sample_rate_converter Testbench");
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
        input [7:0] expected_out_sample;
        begin
            if (expected_out_sample === (expected_out_sample ^ out_sample ^ expected_out_sample)) begin
                $display("PASS");
                $display("  Outputs: out_sample=%h",
                         out_sample);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_sample=%h",
                         expected_out_sample);
                $display("  Got:      out_sample=%h",
                         out_sample);
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
        $dumpvars(0,clk, in_sample, rst, out_sample);
    end

endmodule
