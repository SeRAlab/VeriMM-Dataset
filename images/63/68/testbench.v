`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg DATA_IN;
    reg SHIFT;
    reg clk;
    wire [31:0] DATA_OUT;
    wire SHIFT_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DATA_IN(DATA_IN),
        .SHIFT(SHIFT),
        .clk(clk),
        .DATA_OUT(DATA_OUT),
        .SHIFT_OUT(SHIFT_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        integer i;
        begin
            SHIFT = 0;
            DATA_IN = 0;
            repeat(32) @(negedge clk);
            $display("Status: DUT cleared to 0.");
        end
        endtask
    task testcase001;

        reg [31:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            reset_dut();
            pattern = 32'h12345678;

            $display("Testcase %0d: Loading pattern %h", test_num, pattern);
            for (i = 0; i < 32; i = i + 1) begin
                @(negedge clk);
                SHIFT = 0;
                DATA_IN = pattern[31-i];
            end
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678, 1'b0);
        end
        endtask

    task testcase002;

        reg [31:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            reset_dut();


            pattern = 32'h000000FF;
            for (i = 0; i < 32; i = i + 1) begin
                @(negedge clk);
                DATA_IN = pattern[31-i];
            end


            @(negedge clk);
            SHIFT = 1;
            DATA_IN = 1;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000FF0, 1'b0);
        end
        endtask

    task testcase003;

        reg [31:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            reset_dut();


            pattern = 32'h80000001;
            for (i = 0; i < 32; i = i + 1) begin
                @(negedge clk);
                DATA_IN = pattern[31-i];
            end

            @(posedge clk);
            #1;
            $display("Testcase %0d: Checking SHIFT_OUT for MSB=1", test_num);
            #1;

            check_outputs(32'h80000001, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            reset_dut();


            for (i = 0; i < 32; i = i + 1) begin
                @(negedge clk);
                DATA_IN = 1;
            end


            @(negedge clk);
            SHIFT = 1;
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFF0000, 1'b1);
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
        input [31:0] expected_DATA_OUT;
        input expected_SHIFT_OUT;
        begin
            if (expected_DATA_OUT === (expected_DATA_OUT ^ DATA_OUT ^ expected_DATA_OUT) &&
                expected_SHIFT_OUT === (expected_SHIFT_OUT ^ SHIFT_OUT ^ expected_SHIFT_OUT)) begin
                $display("PASS");
                $display("  Outputs: DATA_OUT=%h, SHIFT_OUT=%b",
                         DATA_OUT, SHIFT_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATA_OUT=%h, SHIFT_OUT=%b",
                         expected_DATA_OUT, expected_SHIFT_OUT);
                $display("  Got:      DATA_OUT=%h, SHIFT_OUT=%b",
                         DATA_OUT, SHIFT_OUT);
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
        $dumpvars(0,DATA_IN, SHIFT, clk, DATA_OUT, SHIFT_OUT);
    end

endmodule
