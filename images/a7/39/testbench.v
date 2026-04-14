`timescale 1ns/1ps

module adder_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg rst_n;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst_n(rst_n),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        a = 8'h0;
        b = 8'h0;
        @(posedge clk);
        #1;
        rst_n = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Test Case %0d: Basic Addition (10 + 20)", test_num);
        a = 8'd10;
        b = 8'd20;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'd30);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Test Case %0d: Addition with Zero (255 + 0)", test_num);
        a = 8'd255;
        b = 8'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Test Case %0d: Wrap-around (255 + 1)", test_num);
        a = 8'hFF;
        b = 8'h01;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Test Case %0d: Wrap-around (255 + 255)", test_num);
        a = 8'd255;
        b = 8'd255;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'd254);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;

        a = 8'hAA;
        b = 8'h55;
        @(posedge clk);
        #1;
        rst_n = 0;
        @(posedge clk);
        #1;
        $display("Test Case %0d: Verify Reset (Output should be 0)", test_num);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        $display("Test Case %0d: Bit Pattern (0x55 + 0xAA)", test_num);
        a = 8'h55;
        b = 8'hAA;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder Testbench");
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
        input [7:0] expected_sum;
        begin
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
        $dumpvars(0,a, b, clk, rst_n, sum);
    end

endmodule
