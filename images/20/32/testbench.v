`timescale 1ns/1ps

module checksum_calculator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    reg enable;
    wire [4:0] checksum_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    checksum_calculator dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .checksum_out(checksum_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            data_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Basic Accumulation (5 + 10)");
            reset_dut();
            enable = 1;
            data_in = 5'd5;
            @(posedge clk);
            #1;
            data_in = 5'd10;
            @(posedge clk);
            #1;
            enable = 0;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Enable Signal Check (10 + [20 ignored] + 5)");
            reset_dut();
            enable = 1;
            data_in = 5'd10;
            @(posedge clk);
            #1;
            enable = 0;
            data_in = 5'd20;
            @(posedge clk);
            #1;
            enable = 1;
            data_in = 5'd5;
            @(posedge clk);
            #1;
            enable = 0;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Modulo 32 Wrap-around (30 + 5 = 3)");
            reset_dut();
            enable = 1;
            data_in = 5'd30;
            @(posedge clk);
            #1;
            data_in = 5'd5;
            @(posedge clk);
            #1;
            enable = 0;
            #1;

            check_outputs(5'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Consecutive Max Values (31 + 31 = 30)");
            reset_dut();
            enable = 1;
            data_in = 5'd31;
            @(posedge clk);
            #1;
            data_in = 5'd31;
            @(posedge clk);
            #1;
            enable = 0;
            #1;

            check_outputs(5'd30);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Zero Accumulation and Idle State");
            reset_dut();
            enable = 1;
            data_in = 5'd0;
            @(posedge clk);
            #1;
            data_in = 5'd0;
            @(posedge clk);
            #1;
            enable = 0;
            data_in = 5'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("checksum_calculator Testbench");
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
        input [4:0] expected_checksum_out;
        begin
            if (expected_checksum_out === (expected_checksum_out ^ checksum_out ^ expected_checksum_out)) begin
                $display("PASS");
                $display("  Outputs: checksum_out=%h",
                         checksum_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum_out=%h",
                         expected_checksum_out);
                $display("  Got:      checksum_out=%h",
                         checksum_out);
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
        $dumpvars(0,clk, data_in, enable, checksum_out);
    end

endmodule
