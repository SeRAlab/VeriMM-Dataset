`timescale 1ns/1ps

module sipo_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg serial_in;
    wire [4:0] parallel_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sipo_shift_register dut (
        .clk(clk),
        .reset(reset),
        .serial_in(serial_in),
        .parallel_out(parallel_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            serial_in = 0;
            @(negedge clk);
            reset = 0;

            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Shifting in 11111", test_num);
            reset_dut();
            repeat(5) begin
                serial_in = 1'b1;
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(5'b11111, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Shifting in 00000", test_num);
            reset_dut();
            repeat(5) begin
                serial_in = 1'b0;
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(5'b00000, 1'b1);
        end
        endtask

    task testcase003;

        reg [4:0] pattern;
        integer i;
        begin
            test_num = 3;
            pattern = 5'b10101;
            $display("Test Case %0d: Shifting in %b", test_num, pattern);
            reset_dut();
            for (i = 4; i >= 0; i = i - 1) begin
                serial_in = pattern[i];
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(5'b10101, 1'b1);
        end
        endtask

    task testcase004;

        reg [4:0] pattern;
        integer i;
        begin
            test_num = 4;
            pattern = 5'b01100;
            $display("Test Case %0d: Shifting in %b", test_num, pattern);
            reset_dut();
            for (i = 4; i >= 0; i = i - 1) begin
                serial_in = pattern[i];
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(5'b01100, 1'b1);
        end
        endtask

    task testcase005;

        reg [4:0] pattern;
        integer i;
        begin
            test_num = 5;
            pattern = 5'b00111;
            $display("Test Case %0d: Shifting in %b", test_num, pattern);
            reset_dut();
            for (i = 4; i >= 0; i = i - 1) begin
                serial_in = pattern[i];
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(5'b00111, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sipo_shift_register Testbench");
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
        input [4:0] expected_parallel_out;
        input expected_valid;
        begin
            if (expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: parallel_out=%h, valid=%b",
                         parallel_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallel_out=%h, valid=%b",
                         expected_parallel_out, expected_valid);
                $display("  Got:      parallel_out=%h, valid=%b",
                         parallel_out, valid);
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
        $dumpvars(0,clk, reset, serial_in, parallel_out, valid);
    end

endmodule
