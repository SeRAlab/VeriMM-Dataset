`timescale 1ns/1ps

module subtractor_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg rst_n;
    wire [7:0] diff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    subtractor dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst_n(rst_n),
        .diff(diff)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        a = 0;
        b = 0;
        @(posedge clk);
        #1;
        rst_n = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        a = 8'd50;
        b = 8'd20;
        @(posedge clk);
        #2;
        $write("Testcase 001: 50 - 20... ");
        #1;

        check_outputs(8'd30);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        a = 8'hFF;
        b = 8'hFF;
        @(posedge clk);
        #2;
        $write("Testcase 002: 255 - 255... ");
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        a = 8'd0;
        b = 8'd1;
        @(posedge clk);
        #2;
        $write("Testcase 003: 0 - 1 (Underflow)... ");
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        a = 8'd128;
        b = 8'd0;
        @(posedge clk);
        #2;
        $write("Testcase 004: 128 - 0... ");
        #1;

        check_outputs(8'd128);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        a = 8'd10;
        b = 8'd20;
        @(posedge clk);
        #2;
        $write("Testcase 005: 10 - 20 (Wrap)... ");
        #1;

        check_outputs(8'd246);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        a = 8'd255;
        b = 8'd1;
        @(posedge clk);
        #2;
        $write("Testcase 006: 255 - 1... ");
        #1;

        check_outputs(8'd254);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        a = 8'd100;
        b = 8'd50;
        @(posedge clk);
        #1 rst_n = 0;
        @(posedge clk);
        #2;
        $write("Testcase 007: Checking reset state... ");
        #1;

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
        $display("subtractor Testbench");
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
        input [7:0] expected_diff;
        begin
            if (expected_diff === (expected_diff ^ diff ^ expected_diff)) begin
                $display("PASS");
                $display("  Outputs: diff=%h",
                         diff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: diff=%h",
                         expected_diff);
                $display("  Got:      diff=%h",
                         diff);
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
        $dumpvars(0,a, b, clk, rst_n, diff);
    end

endmodule
