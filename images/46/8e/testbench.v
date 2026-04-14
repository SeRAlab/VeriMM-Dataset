`timescale 1ns/1ps

module ShiftRegister_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    reg serial_in;
    wire [7:0] parallel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ShiftRegister dut (
        .clk(clk),
        .rst_n(rst_n),
        .serial_in(serial_in),
        .parallel_out(parallel_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        serial_in = 0;
        @(posedge clk);
        #1;
        rst_n = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Behavior", test_num);
        reset_dut();

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift in 8 ones", test_num);
        reset_dut();
        for (i = 0; i < 8; i = i + 1) begin
            serial_in = 1;
            @(posedge clk);
            #1;
        end
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    integer i;
    reg [7:0] pattern;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift in pattern 0xAA", test_num);
        reset_dut();
        pattern = 8'hAA;

        for (i = 7; i >= 0; i = i - 1) begin
            serial_in = pattern[i];
            @(posedge clk);
            #1;
        end
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase004;

    integer i;
    reg [7:0] pattern;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift in pattern 0x55", test_num);
        reset_dut();
        pattern = 8'h55;
        for (i = 7; i >= 0; i = i - 1) begin
            serial_in = pattern[i];
            @(posedge clk);
            #1;
        end
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase005;

    integer i;
    reg [11:0] long_pattern;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Overflow Check (12 bits)", test_num);
        reset_dut();

        long_pattern = 12'hB6C;
        for (i = 11; i >= 0; i = i - 1) begin
            serial_in = long_pattern[i];
            @(posedge clk);
            #1;
        end

        #1;


        check_outputs(8'h6C);
    end
        endtask

    task testcase006;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Partial Shift Check (4 bits)", test_num);
        reset_dut();

        for (i = 0; i < 4; i = i + 1) begin
            serial_in = 1;
            @(posedge clk);
            #1;
        end

        #1;


        check_outputs(8'h0F);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ShiftRegister Testbench");
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
        input [7:0] expected_parallel_out;
        begin
            if (expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out)) begin
                $display("PASS");
                $display("  Outputs: parallel_out=%h",
                         parallel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallel_out=%h",
                         expected_parallel_out);
                $display("  Got:      parallel_out=%h",
                         parallel_out);
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
        $dumpvars(0,clk, rst_n, serial_in, parallel_out);
    end

endmodule
