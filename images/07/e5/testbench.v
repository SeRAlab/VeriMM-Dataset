`timescale 1ns/1ps

module wifi_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg connect;
    wire [1:0] status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wifi_module dut (
        .clk(clk),
        .connect(connect),
        .status(status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            connect = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Connection Flow 0 -> 1 -> 2");
            reset_dut();
            connect = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Disconnect after connection (2 -> 0)");
            reset_dut();
            connect = 1;
            @(posedge clk);
            @(posedge clk);
            connect = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Disconnect during 'Connecting' (1 -> 0)");
            reset_dut();
            connect = 1;
            @(posedge clk);
            connect = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Stay Idle (status 0)");
            reset_dut();
            connect = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Maintain Connection (status 2)");
            reset_dut();
            connect = 1;
            @(posedge clk);
            @(posedge clk);
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(2'd2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wifi_module Testbench");
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
        input [1:0] expected_status;
        begin
            if (expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: status=%h",
                         status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: status=%h",
                         expected_status);
                $display("  Got:      status=%h",
                         status);
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
        $dumpvars(0,clk, connect, status);
    end

endmodule
