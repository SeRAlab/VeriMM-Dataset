`timescale 1ns/1ps

module zero_crossing_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in_signal;
    wire zero_cross;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    zero_crossing_detector dut (
        .clk(clk),
        .in_signal(in_signal),
        .zero_cross(zero_cross)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        in_signal = 8'd0;
        @(posedge clk);
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        in_signal = -8'd10;
        @(posedge clk);
        in_signal = 8'd10;
        @(posedge clk);
        #1;
        $display("Testcase 001: Negative to Positive (-10 to 10)");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        in_signal = -8'd5;
        @(posedge clk);
        in_signal = 8'd0;
        @(posedge clk);
        #1;
        $display("Testcase 002: Negative to Zero (-5 to 0)");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        in_signal = 8'd10;
        @(posedge clk);
        in_signal = -8'd10;
        @(posedge clk);
        #1;
        $display("Testcase 003: Falling edge (10 to -10)");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        in_signal = 8'd5;
        @(posedge clk);
        in_signal = 8'd15;
        @(posedge clk);
        #1;
        $display("Testcase 004: Stay Positive (5 to 15)");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        in_signal = -8'd20;
        @(posedge clk);
        in_signal = -8'd5;
        @(posedge clk);
        #1;
        $display("Testcase 005: Stay Negative (-20 to -5)");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        in_signal = 8'd0;
        @(posedge clk);
        in_signal = 8'd5;
        @(posedge clk);
        #1;
        $display("Testcase 006: Zero to Positive (0 to 5)");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        in_signal = -8'd128;
        @(posedge clk);
        in_signal = 8'd127;
        @(posedge clk);
        #1;
        $display("Testcase 007: Min to Max (-128 to 127)");
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
        $display("zero_crossing_detector Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_zero_cross;
        begin
            if (expected_zero_cross === (expected_zero_cross ^ zero_cross ^ expected_zero_cross)) begin
                $display("PASS");
                $display("  Outputs: zero_cross=%b",
                         zero_cross);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: zero_cross=%b",
                         expected_zero_cross);
                $display("  Got:      zero_cross=%b",
                         zero_cross);
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
        $dumpvars(0,clk, in_signal, zero_cross);
    end

endmodule
