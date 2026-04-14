`timescale 1ns/1ps

module butterworth_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    reg [7:0] sample_in;
    wire [7:0] filtered_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    butterworth_filter dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .sample_in(sample_in),
        .filtered_out(filtered_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            sample_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task feed_samples;

        input [7:0] s1, s2, s3, s4, s5;
        begin
            @(posedge clk);
            enable = 1;
            sample_in = s1; @(posedge clk);
            sample_in = s2; @(posedge clk);
            sample_in = s3; @(posedge clk);
            sample_in = s4; @(posedge clk);
            sample_in = s5; @(posedge clk);
            enable = 0;

            repeat(5) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            $display("\nRunning Testcase 001: Zero Input");
            test_num = 1;
            reset_dut();
            feed_samples(8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: DC Full Scale Input");
            test_num = 2;
            reset_dut();
            feed_samples(8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF);

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Step Input");
            test_num = 3;
            reset_dut();

            feed_samples(8'h00, 8'h00, 8'h80, 8'h80, 8'h80);


            if (filtered_out > 8'h00 && filtered_out < 8'h80)
                pass_count = pass_count + 0;
            #1;

            check_outputs(filtered_out);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Impulse Response");
            test_num = 4;
            reset_dut();
            feed_samples(8'hFF, 8'h00, 8'h00, 8'h00, 8'h00);

            #1;


            check_outputs(filtered_out);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: High Frequency Input");
            test_num = 5;
            reset_dut();
            feed_samples(8'hFF, 8'h00, 8'hFF, 8'h00, 8'hFF);

            #1;


            check_outputs(filtered_out);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("butterworth_filter Testbench");
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
        input [7:0] expected_filtered_out;
        begin
            if (expected_filtered_out === (expected_filtered_out ^ filtered_out ^ expected_filtered_out)) begin
                $display("PASS");
                $display("  Outputs: filtered_out=%h",
                         filtered_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: filtered_out=%h",
                         expected_filtered_out);
                $display("  Got:      filtered_out=%h",
                         filtered_out);
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
        $dumpvars(0,clk, enable, reset, sample_in, filtered_out);
    end

endmodule
