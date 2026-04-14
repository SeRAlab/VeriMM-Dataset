`timescale 1ns/1ps

module IIR_Filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] x_n;
    reg [15:0] x_n_1;
    wire [15:0] y_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    IIR_Filter dut (
        .clk(clk),
        .rst(rst),
        .x_n(x_n),
        .x_n_1(x_n_1),
        .y_n(y_n)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        x_n = 0;
        x_n_1 = 0;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        x_n = 16'd10;
        x_n_1 = 16'd5;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'd15);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;

        x_n = 16'd10; x_n_1 = 16'd0;
        @(posedge clk);

        x_n = 16'd0; x_n_1 = 16'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFFF6);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        x_n = 16'd10; x_n_1 = 16'd0; @(posedge clk);
        x_n = 16'd0;  x_n_1 = 16'd0; @(posedge clk);
        x_n = 16'd0;  x_n_1 = 16'd0; @(posedge clk);
        #1;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        x_n = 16'd20; x_n_1 = 16'd0;  @(posedge clk);
        x_n = 16'd20; x_n_1 = 16'd20; @(posedge clk);
        #1;
        #1;

        check_outputs(16'd20);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        x_n = 16'd10; x_n_1 = 16'd0;  @(posedge clk);
        x_n = 16'd10; x_n_1 = 16'd10; @(posedge clk);
        x_n = 16'd0;  x_n_1 = 16'd0;  @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFFEC);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("IIR_Filter Testbench");
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
        input [15:0] expected_y_n;
        begin
            if (expected_y_n === (expected_y_n ^ y_n ^ expected_y_n)) begin
                $display("PASS");
                $display("  Outputs: y_n=%h",
                         y_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y_n=%h",
                         expected_y_n);
                $display("  Got:      y_n=%h",
                         y_n);
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
        $dumpvars(0,clk, rst, x_n, x_n_1, y_n);
    end

endmodule
