`timescale 1ns/1ps

module IFFT_8x8_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] data_in;
    reg rst;
    wire [63:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    IFFT_8x8 dut (
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
        repeat(2) @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: All Zeros", test_num);
        reset_dut();
        data_in = 128'h0;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(128'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: DC Impulse (Constant Output)", test_num);
        reset_dut();

        data_in = 128'h0000_0000_0000_0000_0000_0000_0000_0800;
        repeat(10) @(posedge clk);

        #1;


        check_outputs(128'h0100_0100_0100_0100_0100_0100_0100_0100);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Spectral Constant (Time Delta)", test_num);
        reset_dut();

        data_in = 128'h0800_0800_0800_0800_0800_0800_0800_0800;
        repeat(10) @(posedge clk);

        #1;


        check_outputs(128'h0000_0000_0000_0000_0000_0000_0000_0800);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Imaginary DC Impulse", test_num);
        reset_dut();

        data_in = 128'h0000_0000_0000_0000_0000_0000_0000_0008;
        repeat(10) @(posedge clk);

        #1;


        check_outputs(128'h0001_0001_0001_0001_0001_0001_0001_0001);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Nyquist Frequency (Alternating Output)", test_num);
        reset_dut();

        data_in = 128'h0000_0000_0000_1000_0000_0000_0000_0000;
        repeat(10) @(posedge clk);


        #1;



        check_outputs(128'hFE00_0200_FE00_0200_FE00_0200_FE00_0200);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("IFFT_8x8 Testbench");
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
        input [63:0] expected_data_out;
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
