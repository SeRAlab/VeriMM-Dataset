`timescale 1ns/1ps

module timer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [7:0] start_val;
    wire [7:0] current_val;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    timer dut (
        .clk(clk),
        .rst(rst),
        .start_val(start_val),
        .current_val(current_val)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Basic countdown 10 -> 5");
            test_num = 1;
            start_val = 8'd10;
            reset_dut();
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(8'd5);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Countdown to zero 10 -> 0");
            test_num = 2;
            start_val = 8'd10;
            reset_dut();
            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Saturation at zero 5 -> 0 (stay at 0)");
            test_num = 3;
            start_val = 8'd5;
            reset_dut();
            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(8'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Maximum value countdown 255 -> 0");
            test_num = 4;
            start_val = 8'hFF;
            reset_dut();
            repeat(255) @(posedge clk);
            #1 #1;
 check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Immediate load check");
            test_num = 5;
            start_val = 8'd50;
            reset_dut();
            #1 #1;
 check_outputs(8'd50);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Starting at zero");
            test_num = 6;
            start_val = 8'd0;
            reset_dut();
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(8'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("timer Testbench");
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
        input [7:0] expected_current_val;
        begin
            if (expected_current_val === (expected_current_val ^ current_val ^ expected_current_val)) begin
                $display("PASS");
                $display("  Outputs: current_val=%h",
                         current_val);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_val=%h",
                         expected_current_val);
                $display("  Got:      current_val=%h",
                         current_val);
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
        $dumpvars(0,clk, rst, start_val, current_val);
    end

endmodule
