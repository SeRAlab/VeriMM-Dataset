`timescale 1ns/1ps

module parallel_to_serial_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    parallel_to_serial dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        input [7:0] data;
        begin
            @(negedge clk);
            reset = 1;
            data_in = data;
            @(negedge clk);
            reset = 0;

        end
        endtask
    task testcase001;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            pattern = 8'hA5;
            $display("\nStarting Testcase %0d: Data = %b", test_num, pattern);
            reset_dut(pattern);
            for (i = 0; i < 8; i = i + 1) begin
                #1;

                check_outputs(pattern[7-i]);
                @(negedge clk);
            end
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            pattern = 8'h5A;
            $display("\nStarting Testcase %0d: Data = %b", test_num, pattern);
            reset_dut(pattern);
            for (i = 0; i < 8; i = i + 1) begin
                #1;

                check_outputs(pattern[7-i]);
                @(negedge clk);
            end
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            pattern = 8'hFF;
            $display("\nStarting Testcase %0d: Data = %b", test_num, pattern);
            reset_dut(pattern);
            for (i = 0; i < 8; i = i + 1) begin
                #1;

                check_outputs(pattern[7-i]);
                @(negedge clk);
            end
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            pattern = 8'h00;
            $display("\nStarting Testcase %0d: Data = %b", test_num, pattern);
            reset_dut(pattern);
            for (i = 0; i < 8; i = i + 1) begin
                #1;

                check_outputs(pattern[7-i]);
                @(negedge clk);
            end
        end
        endtask

    task testcase005;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            pattern = 8'h80;
            $display("\nStarting Testcase %0d: Data = %b", test_num, pattern);
            reset_dut(pattern);
            for (i = 0; i < 8; i = i + 1) begin
                #1;

                check_outputs(pattern[7-i]);
                @(negedge clk);
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("parallel_to_serial Testbench");
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
        input expected_serial_out;
        begin
            if (expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: serial_out=%b",
                         serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: serial_out=%b",
                         expected_serial_out);
                $display("  Got:      serial_out=%b",
                         serial_out);
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
        $dumpvars(0,clk, data_in, reset, serial_out);
    end

endmodule
