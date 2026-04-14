`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] stream_in_data;
    reg [63:0] stream_in_data_wide;
    reg stream_in_valid;
    reg stream_out_ready;
    wire stream_in_ready;
    wire [7:0] stream_out_data_comb;
    wire [7:0] stream_out_data_registered;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .stream_in_data(stream_in_data),
        .stream_in_data_wide(stream_in_data_wide),
        .stream_in_valid(stream_in_valid),
        .stream_out_ready(stream_out_ready),
        .stream_in_ready(stream_in_ready),
        .stream_out_data_comb(stream_out_data_comb),
        .stream_out_data_registered(stream_out_data_registered)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            stream_in_data = 8'h0;
            stream_in_data_wide = 64'h0;
            stream_in_valid = 0;
            stream_out_ready = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase001: Basic Data and Ready Check");
            reset_dut();
            stream_in_data = 8'hA5;
            stream_out_ready = 1;
            stream_in_valid = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b1, 8'hA5, 8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase002: Ready Signal De-assertion");
            reset_dut();
            stream_in_data = 8'h5A;
            stream_out_ready = 0;
            stream_in_valid = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 8'h5A, 8'h5A);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase003: Pipeline Logic Check");
            reset_dut();


            stream_in_data = 8'h11;
            stream_out_ready = 1;
            @(posedge clk);
            #1;


            stream_in_data = 8'h22;
            @(posedge clk);
            #1;



            stream_in_data = 8'h33;
            #2;

            #1;


            check_outputs(1'b1, 8'h33, 8'h22);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase004: Wide Data Input Stability");
            reset_dut();
            stream_in_data = 8'hFF;
            stream_in_data_wide = 64'hFEDCBA9876543210;
            stream_out_ready = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b1, 8'hFF, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase005: Valid Signal Logic");
            reset_dut();
            stream_in_data = 8'hBC;
            stream_in_valid = 0;
            stream_out_ready = 1;

            @(posedge clk);
            #2;



            #1;




            check_outputs(1'b1, 8'hBC, 8'hBC);
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
        input expected_stream_in_ready;
        input [7:0] expected_stream_out_data_comb;
        input [7:0] expected_stream_out_data_registered;
        begin
            if (expected_stream_in_ready === (expected_stream_in_ready ^ stream_in_ready ^ expected_stream_in_ready) &&
                expected_stream_out_data_comb === (expected_stream_out_data_comb ^ stream_out_data_comb ^ expected_stream_out_data_comb) &&
                expected_stream_out_data_registered === (expected_stream_out_data_registered ^ stream_out_data_registered ^ expected_stream_out_data_registered)) begin
                $display("PASS");
                $display("  Outputs: stream_in_ready=%b, stream_out_data_comb=%h, stream_out_data_registered=%h",
                         stream_in_ready, stream_out_data_comb, stream_out_data_registered);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stream_in_ready=%b, stream_out_data_comb=%h, stream_out_data_registered=%h",
                         expected_stream_in_ready, expected_stream_out_data_comb, expected_stream_out_data_registered);
                $display("  Got:      stream_in_ready=%b, stream_out_data_comb=%h, stream_out_data_registered=%h",
                         stream_in_ready, stream_out_data_comb, stream_out_data_registered);
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
        $dumpvars(0,clk, stream_in_data, stream_in_data_wide, stream_in_valid, stream_out_ready, stream_in_ready, stream_out_data_comb, stream_out_data_registered);
    end

endmodule
