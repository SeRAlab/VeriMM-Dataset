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
            in_sample = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            in_sample = 8'd10;
            @(posedge clk);
            #1;
            in_sample = 8'd20;
            @(posedge clk);
            #2;
            $display("Testcase 001: Input 10, 20");
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            in_sample = 8'd100;
            @(posedge clk);
            #1;
            in_sample = 8'd100;
            @(posedge clk);
            #2;
            $display("Testcase 002: Input 100, 100");
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            in_sample = 8'd5;
            @(posedge clk);
            #1;
            in_sample = 8'd6;
            @(posedge clk);
            #2;
            $display("Testcase 003: Input 5, 6 (Truncation check)");
            #1;

            check_outputs(8'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            in_sample = 8'd255;
            @(posedge clk);
            #1;
            in_sample = 8'd0;
            @(posedge clk);
            #2;
            $display("Testcase 004: Input 255, 0");
            #1;

            check_outputs(8'd127);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            in_sample = 8'd255;
            @(posedge clk);
            #1;
            in_sample = 8'd255;
            @(posedge clk);
            #2;
            $display("Testcase 005: Input 255, 255 (Overflow check)");
            #1;

            check_outputs(8'd255);
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
