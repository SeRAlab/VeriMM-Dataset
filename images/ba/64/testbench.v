`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] din;
    reg new_data_rdy;
    wire [15:0] dout;
    wire output_data_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .new_data_rdy(new_data_rdy),
        .dout(dout),
        .output_data_ready(output_data_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            new_data_rdy = 0;
            din = 0;
            repeat(5) @(posedge clk);
            $display("Reset completed.");
        end
        endtask
    task send_sample;

        input [15:0] value;
        begin
            @(posedge clk);
            #1;
            new_data_rdy = 1;
            din = value;
            @(posedge clk);
            #1;
            new_data_rdy = 0;
            din = 0;

            wait(output_data_ready == 1);
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            $display("Running testcase001: Impulse Response...");
            reset_dut();
            send_sample(16'd1);
            send_sample(16'd0);
            send_sample(16'd0);
            send_sample(16'd0);
            send_sample(16'd0);
            send_sample(16'd0);
            send_sample(16'd0);




            #1;





            check_outputs(16'h0001, 1'b1);
        end
        endtask

    task testcase002;

        reg [15:0] expected_val;
        begin
            $display("Running testcase002: DC Gain...");
            reset_dut();
            expected_val = 16'd10 * (C0 + C1 + C2 + C3 + C4 + C5 + C6);

            send_sample(16'd10);
            send_sample(16'd10);
            send_sample(16'd10);
            send_sample(16'd10);
            send_sample(16'd10);
            send_sample(16'd10);
            send_sample(16'd10);

            #1;


            check_outputs(expected_val, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Zero Input...");
            reset_dut();
            send_sample(16'hFFFF);
            send_sample(16'd0);
            send_sample(16'd0);
            send_sample(16'd0);
            send_sample(16'd0);
            send_sample(16'd0);
            send_sample(16'd0);
            send_sample(16'd0);

            #1;


            check_outputs(16'h0000, 1'b1);
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
        input [15:0] expected_dout;
        input expected_output_data_ready;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_output_data_ready === (expected_output_data_ready ^ output_data_ready ^ expected_output_data_ready)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, output_data_ready=%b",
                         dout, output_data_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, output_data_ready=%b",
                         expected_dout, expected_output_data_ready);
                $display("  Got:      dout=%h, output_data_ready=%b",
                         dout, output_data_ready);
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
        $dumpvars(0,clk, din, new_data_rdy, dout, output_data_ready);
    end

endmodule
