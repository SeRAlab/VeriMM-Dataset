`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] din;
    reg new_data_rdy;
    wire [27:0] dout;
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
            $display("Resetting/Initializing Filter...");
            din = 0;
            new_data_rdy = 0;
            @(posedge clk);
            repeat(10) begin
                din = 0;
                new_data_rdy = 1;
                @(posedge clk);
            end
            new_data_rdy = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase 001: DC Response (Small)");
            repeat(6) begin
                din = 16'd10;
                new_data_rdy = 1;
                @(posedge clk);
            end

            #1;
            #1;

            check_outputs(28'd150, 1'b1);
            new_data_rdy = 0;
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase 002: Impulse Response Tail");


            din = 16'd100;
            new_data_rdy = 1;
            @(posedge clk);


            repeat(5) begin
                din = 16'd0;
                new_data_rdy = 1;
                @(posedge clk);
            end

            #1;
            #1;

            check_outputs(28'd200, 1'b1);
            new_data_rdy = 0;
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase 003: DC Response (Large)");
            repeat(6) begin
                din = 16'd1000;
                new_data_rdy = 1;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(28'd15000, 1'b1);
            new_data_rdy = 0;
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase 004: Intermittent Data Check");


            repeat(5) begin
                din = 16'd10;
                new_data_rdy = 1;
                @(posedge clk);
            end


            new_data_rdy = 0;
            din = 16'hFFFF;
            repeat(3) @(posedge clk);


            din = 16'd10;
            new_data_rdy = 1;
            @(posedge clk);

            #1;
            #1;

            check_outputs(28'd150, 1'b1);
            new_data_rdy = 0;
            @(posedge clk);
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
        input [27:0] expected_dout;
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
