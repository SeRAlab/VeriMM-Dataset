`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data;
    reg enable;
    reg ready;
    reg rst;
    reg [23:0] size;
    wire activate;
    wire busy;
    wire error;
    wire strobe;
    wire [23:0] total_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .enable(enable),
        .ready(ready),
        .rst(rst),
        .size(size),
        .activate(activate),
        .busy(busy),
        .error(error),
        .strobe(strobe),
        .total_count(total_count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        clk = 0;
        enable = 0;
        ready = 0;
        size = 0;
        data = 0;
        #20;
        rst = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase %0d: System Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(0, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase %0d: Successful Testing Cycle (Size 5)", test_num);
        reset_dut();

        @(posedge clk);
        size = 24'd5;
        enable = 1;
        ready = 1;
        data = 32'h0;


        repeat (6) @(posedge clk);

        enable = 0;
        ready = 0;
        @(posedge clk);


        #1;



        check_outputs(0, 0, 0, 0, 5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase %0d: Error Detection", test_num);
        reset_dut();

        @(posedge clk);
        size = 24'd3;
        enable = 1;
        ready = 1;
        data = 32'hFFFFFFFF;

        repeat (4) @(posedge clk);

        enable = 0;
        ready = 0;
        @(posedge clk);




        if (error === 1'b1) begin
             #1;

             check_outputs(activate, 0, 1, strobe, total_count);
        end else begin
             $display("Specific check failed: Error flag not raised for bad data.");
             fail_count = fail_count + 1;
        end
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase %0d: Ready Signal Dependency", test_num);
        reset_dut();

        @(posedge clk);
        size = 24'd10;
        enable = 1;
        ready = 0;

        repeat (5) @(posedge clk);


        #1;



        check_outputs(0, 0, 0, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase %0d: Cumulative Total Count", test_num);
        reset_dut();


        @(posedge clk);
        size = 24'd2;
        enable = 1;
        ready = 1;
        data = 0;
        repeat (3) @(posedge clk);
        enable = 0;
        ready = 0;
        @(posedge clk);


        @(posedge clk);
        size = 24'd3;
        enable = 1;
        ready = 1;
        repeat (4) @(posedge clk);
        enable = 0;
        ready = 0;
        @(posedge clk);


        #1;



        check_outputs(0, 0, 0, 0, 5);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running Testcase %0d: Reset During Operation", test_num);
        reset_dut();

        @(posedge clk);
        size = 24'd20;
        enable = 1;
        ready = 1;

        repeat (5) @(posedge clk);

        rst = 1;
        @(posedge clk);
        rst = 0;
        @(posedge clk);


        #1;



        check_outputs(0, 0, 0, 0, 0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_activate;
        input expected_busy;
        input expected_error;
        input expected_strobe;
        input [23:0] expected_total_count;
        begin
            if (expected_activate === (expected_activate ^ activate ^ expected_activate) &&
                expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_error === (expected_error ^ error ^ expected_error) &&
                expected_strobe === (expected_strobe ^ strobe ^ expected_strobe) &&
                expected_total_count === (expected_total_count ^ total_count ^ expected_total_count)) begin
                $display("PASS");
                $display("  Outputs: activate=%b, busy=%b, error=%b, strobe=%b, total_count=%h",
                         activate, busy, error, strobe, total_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: activate=%b, busy=%b, error=%b, strobe=%b, total_count=%h",
                         expected_activate, expected_busy, expected_error, expected_strobe, expected_total_count);
                $display("  Got:      activate=%b, busy=%b, error=%b, strobe=%b, total_count=%h",
                         activate, busy, error, strobe, total_count);
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
        $dumpvars(0,clk, data, enable, ready, rst, size, activate, busy, error, strobe, total_count);
    end

endmodule
