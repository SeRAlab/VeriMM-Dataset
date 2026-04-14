`timescale 1ns/1ps

module timer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg rst;
    reg [7:0] threshold;
    wire [7:0] count;
    wire threshold_reached;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    timer dut (
        .clk(clk),
        .enable(enable),
        .rst(rst),
        .threshold(threshold),
        .count(count),
        .threshold_reached(threshold_reached)
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
            threshold = 8'h00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic count to threshold", test_num);
            reset_dut();
            threshold = 8'd10;
            enable = 1;
            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(8'd10, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Enable/Disable control", test_num);
            reset_dut();
            threshold = 8'd20;
            enable = 1;
            repeat(5) @(posedge clk);
            enable = 0;
            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(8'd5, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Wrap-around (255 to 0)", test_num);
            reset_dut();
            threshold = 8'd50;
            enable = 1;
            repeat(256) @(posedge clk);
            #1 #1;
 check_outputs(8'd0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Maximum threshold (255)", test_num);
            reset_dut();
            threshold = 8'd255;
            enable = 1;
            repeat(255) @(posedge clk);
            #1 #1;
 check_outputs(8'd255, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Zero threshold logic", test_num);
            reset_dut();
            threshold = 8'd0;
            enable = 1;
            repeat(256) @(posedge clk);
            #1 #1;
 check_outputs(8'd0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Reset during operation", test_num);
            reset_dut();
            threshold = 8'd100;
            enable = 1;
            repeat(50) @(posedge clk);
            rst = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd0, 1'b0);
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
        input [7:0] expected_count;
        input expected_threshold_reached;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_threshold_reached === (expected_threshold_reached ^ threshold_reached ^ expected_threshold_reached)) begin
                $display("PASS");
                $display("  Outputs: count=%h, threshold_reached=%b",
                         count, threshold_reached);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, threshold_reached=%b",
                         expected_count, expected_threshold_reached);
                $display("  Got:      count=%h, threshold_reached=%b",
                         count, threshold_reached);
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
        $dumpvars(0,clk, enable, rst, threshold, count, threshold_reached);
    end

endmodule
