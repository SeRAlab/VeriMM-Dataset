`timescale 1ns/1ps

module FFT_8point_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] data_in;
    reg rst;
    wire [255:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    FFT_8point dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Zeros", test_num);
            reset_dut();
            data_in = 256'h0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(256'h0);
        end
        endtask

    task testcase002;

        reg [255:0] expected;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Impulse at x[0]", test_num);
            reset_dut();
            data_in = {224'h0, 16'h0008, 16'h0000};
            expected = {8{16'h0008, 16'h0000}};
            repeat(10) @(posedge clk);
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase003;

        reg [255:0] expected;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: DC Signal", test_num);
            reset_dut();
            data_in = {8{16'h0001, 16'h0000}};
            expected = {224'h0, 16'h0008, 16'h0000};
            repeat(10) @(posedge clk);
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase004;

        reg [255:0] expected;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Nyquist Frequency", test_num);
            reset_dut();
            data_in = {
                16'hFFFF, 16'h0000,
                16'h0001, 16'h0000,
                16'hFFFF, 16'h0000,
                16'h0001, 16'h0000,
                16'hFFFF, 16'h0000,
                16'h0001, 16'h0000,
                16'hFFFF, 16'h0000,
                16'h0001, 16'h0000
            };

            expected = 256'h0;
            expected[159:128] = {16'h0008, 16'h0000};
            repeat(10) @(posedge clk);
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase005;

        reg [255:0] expected;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Imaginary Impulse", test_num);
            reset_dut();
            data_in = {224'h0, 16'h0000, 16'h0008};
            expected = {8{16'h0000, 16'h0008}};
            repeat(10) @(posedge clk);
            #1;

            check_outputs(expected);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("FFT_8point Testbench");
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
        input [255:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, rst, data_out);
    end

endmodule
