`timescale 1ns/1ps

module fft_16_point_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] data_in;
    reg rst_n;
    wire [127:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_16_point dut (
        .clk(clk),
        .data_in(data_in),
        .rst_n(rst_n),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            data_in = 0;
            @(posedge clk);
            @(posedge clk);
            rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            data_in = 128'h0000_0000_0000_0000_0000_0000_0000_0010;
            repeat(10) @(posedge clk);
            $display("Test Case 001: Unit Impulse (Real)");
            #1;

            check_outputs(128'h1010_1010_1010_1010_1010_1010_1010_1010);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data_in = 128'h0;
            repeat(10) @(posedge clk);
            $display("Test Case 002: All Zeros");
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            data_in = 128'h0000_0000_0000_0000_0000_0000_0000_0001;
            repeat(10) @(posedge clk);
            $display("Test Case 003: Unit Impulse (Imaginary)");
            #1;

            check_outputs(128'h0101_0101_0101_0101_0101_0101_0101_0101);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data_in = 128'h1010_1010_1010_1010_1010_1010_1010_1010;
            repeat(10) @(posedge clk);
            $display("Test Case 004: DC Signal");

            #1;


            check_outputs(128'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fft_16_point Testbench");
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
        input [127:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, rst_n, data_out);
    end

endmodule
