`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] channel_select;
    reg clk;
    reg enable;
    wire [7:0] active_channel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .enable(enable),
        .active_channel(active_channel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            channel_select = 3'b000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Test 001: Selecting Channel 0");
            channel_select = 3'd0;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b0000_0001);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Test 002: Selecting Channel 7");
            channel_select = 3'd7;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b1000_0000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Test 003: Channel 3 selected but Enable is LOW");
            channel_select = 3'd3;
            enable = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b0000_0000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Test 004: Selecting Channel 4");
            channel_select = 3'd4;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b0001_0000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Test 005: Selecting Channel 2");
            channel_select = 3'd2;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b0000_0100);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Test 006: Selecting Channel 5");
            channel_select = 3'd5;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b0010_0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        input [7:0] expected_active_channel;
        begin
            if (expected_active_channel === (expected_active_channel ^ active_channel ^ expected_active_channel)) begin
                $display("PASS");
                $display("  Outputs: active_channel=%h",
                         active_channel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active_channel=%h",
                         expected_active_channel);
                $display("  Got:      active_channel=%h",
                         active_channel);
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
        $dumpvars(0,channel_select, clk, enable, active_channel);
    end

endmodule
