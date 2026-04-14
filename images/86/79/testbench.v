`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_100;
    reg i_gpif_in_ch0_rdy_d;
    reg i_gpif_out_ch0_rdy_d;
    reg rst_n;
    reg stream_in_mode_selected;
    wire [31:0] data_out_stream_in;
    wire o_gpif_we_n_stream_in_;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_100(clk_100),
        .i_gpif_in_ch0_rdy_d(i_gpif_in_ch0_rdy_d),
        .i_gpif_out_ch0_rdy_d(i_gpif_out_ch0_rdy_d),
        .rst_n(rst_n),
        .stream_in_mode_selected(stream_in_mode_selected),
        .data_out_stream_in(data_out_stream_in),
        .o_gpif_we_n_stream_in_(o_gpif_we_n_stream_in_)
    );

    // Clock generation (10ns period)
    initial begin
        clk_100 = 0;
        forever #5 clk_100 = ~clk_100;
    end

        task reset_dut;

        begin
            rst_n = 0;
            stream_in_mode_selected = 0;
            i_gpif_in_ch0_rdy_d = 0;
            i_gpif_out_ch0_rdy_d = 0;
            repeat(5) @(posedge clk_100);
            #1 rst_n = 1;
            repeat(2) @(posedge clk_100);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(32'h0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge clk_100);
            stream_in_mode_selected = 1'b1;
            repeat(5) @(posedge clk_100);

            #1;


            check_outputs(32'h0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(posedge clk_100);
            stream_in_mode_selected = 1'b1;
            i_gpif_in_ch0_rdy_d = 1'b1;
            i_gpif_out_ch0_rdy_d = 1'b1;



            repeat(4) @(posedge clk_100);




            if (data_out_stream_in > 32'h0) begin
                pass_count = pass_count + 1;
                $display("Test Case 003: PASS (Data incremented: %0d)", data_out_stream_in);
            end else begin
                fail_count = fail_count + 1;
                $display("Test Case 003: FAIL (Data stayed 0)");
            end
        end
        endtask

    task testcase004;

        reg [31:0] capture_data;
        begin
            reset_dut();
            stream_in_mode_selected = 1'b1;
            i_gpif_in_ch0_rdy_d = 1'b1;
            i_gpif_out_ch0_rdy_d = 1'b1;
            repeat(5) @(posedge clk_100);


            stream_in_mode_selected = 1'b0;
            repeat(2) @(posedge clk_100);
            capture_data = data_out_stream_in;

            repeat(5) @(posedge clk_100);

            #1;


            check_outputs(capture_data, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            stream_in_mode_selected = 1'b1;
            i_gpif_in_ch0_rdy_d = 1'b1;
            i_gpif_out_ch0_rdy_d = 1'b1;
            repeat(10) @(posedge clk_100);


            rst_n = 0;
            #10;
            rst_n = 1;
            @(posedge clk_100);


            #1;



            check_outputs(32'h0, 1'b1);
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
        input [31:0] expected_data_out_stream_in;
        input expected_o_gpif_we_n_stream_in_;
        begin
            if (expected_data_out_stream_in === (expected_data_out_stream_in ^ data_out_stream_in ^ expected_data_out_stream_in) &&
                expected_o_gpif_we_n_stream_in_ === (expected_o_gpif_we_n_stream_in_ ^ o_gpif_we_n_stream_in_ ^ expected_o_gpif_we_n_stream_in_)) begin
                $display("PASS");
                $display("  Outputs: data_out_stream_in=%h, o_gpif_we_n_stream_in_=%b",
                         data_out_stream_in, o_gpif_we_n_stream_in_);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out_stream_in=%h, o_gpif_we_n_stream_in_=%b",
                         expected_data_out_stream_in, expected_o_gpif_we_n_stream_in_);
                $display("  Got:      data_out_stream_in=%h, o_gpif_we_n_stream_in_=%b",
                         data_out_stream_in, o_gpif_we_n_stream_in_);
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
        $dumpvars(0,clk_100, i_gpif_in_ch0_rdy_d, i_gpif_out_ch0_rdy_d, rst_n, stream_in_mode_selected, data_out_stream_in, o_gpif_we_n_stream_in_);
    end

endmodule
