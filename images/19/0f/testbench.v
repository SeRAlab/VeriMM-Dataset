`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] request;
    reg reset;
    wire [1:0] active_channel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .request(request),
        .reset(reset),
        .active_channel(active_channel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            request = 4'b0000;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Channel 0 alone");
            reset_dut();
            request = 4'b0001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Channel 3 alone");
            reset_dut();
            request = 4'b1000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: All channels requesting - Channel 0 wins");
            reset_dut();
            request = 4'b1111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Channels 1 and 2 requesting - Channel 1 wins");
            reset_dut();
            request = 4'b0110;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Channels 2 and 3 requesting - Channel 2 wins");
            reset_dut();
            request = 4'b1100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Priority preemption (2 then 0)");
            reset_dut();
            request = 4'b0100;
            @(posedge clk);
            #2;
            request = 4'b0101;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'd0);
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
        input [1:0] expected_active_channel;
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
        $dumpvars(0,clk, request, reset, active_channel);
    end

endmodule
