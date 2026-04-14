`timescale 1ns/1ps

module watchdog_timer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    reg [3:0] timeout_value;
    wire timeout_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    watchdog_timer dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .timeout_value(timeout_value),
        .timeout_flag(timeout_flag)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            reset = 1;
            timeout_value = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Normal timeout trigger");
            reset_dut();
            timeout_value = 4'd5;
            enable = 1;

            repeat (6) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Reset before timeout occurs");
            reset_dut();
            timeout_value = 4'd10;
            enable = 1;

            repeat (5) @(posedge clk);

            reset = 1;
            @(posedge clk);
            #1 reset = 0;

            repeat (3) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Timer disabled");
            reset_dut();
            timeout_value = 4'd4;
            enable = 0;

            repeat (10) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Clear flag after timeout");
            reset_dut();
            timeout_value = 4'd3;
            enable = 1;

            repeat (5) @(posedge clk);

            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Minimum timeout value (1)");
            reset_dut();
            timeout_value = 4'd1;
            enable = 1;
            repeat (2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Dynamic timeout value change");
            reset_dut();
            timeout_value = 4'd8;
            enable = 1;
            repeat (4) @(posedge clk);

            timeout_value = 4'd2;
            repeat (2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("watchdog_timer Testbench");
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
        input expected_timeout_flag;
        begin
            if (expected_timeout_flag === (expected_timeout_flag ^ timeout_flag ^ expected_timeout_flag)) begin
                $display("PASS");
                $display("  Outputs: timeout_flag=%b",
                         timeout_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: timeout_flag=%b",
                         expected_timeout_flag);
                $display("  Got:      timeout_flag=%b",
                         timeout_flag);
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
        $dumpvars(0,clk, enable, reset, timeout_value, timeout_flag);
    end

endmodule
