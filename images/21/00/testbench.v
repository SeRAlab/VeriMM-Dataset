`timescale 1ns/1ps

module crc_generator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg [15:0] polynomial;
    reg reset;
    reg start;
    wire [15:0] crc_out;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc_generator dut (
        .clk(clk),
        .data_in(data_in),
        .polynomial(polynomial),
        .reset(reset),
        .start(start),
        .crc_out(crc_out),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            data_in = 0;
            polynomial = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task run_calculation;

        input [15:0] d;
        input [15:0] p;
        begin
            data_in = d;
            polynomial = p;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(ready == 1);
        end
        endtask

    task testcase001;

        begin
            $display("Test Case 001: All Zeros");
            reset_dut();
            run_calculation(16'h0000, 16'h1021);
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: LSB Data (Data=1, Poly=0x1021)");
            reset_dut();
            run_calculation(16'h0001, 16'h1021);
            #1;

            check_outputs(16'h1021, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Data=0x0002, Poly=0x1021");
            reset_dut();
            run_calculation(16'h0002, 16'h1021);
            #1;

            check_outputs(16'h2042, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: MSB Data (Data=0x8000, Poly=0x1021)");
            reset_dut();
            run_calculation(16'h8000, 16'h1021);

            #1;


            check_outputs(16'h1d0f, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Pattern Data (Data=0xAAAA, Poly=0x8005)");
            reset_dut();
            run_calculation(16'hAAAA, 16'h8005);
            #1;

            check_outputs(16'h0E01, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Data=0x1234, Poly=0x1021");
            reset_dut();
            run_calculation(16'h1234, 16'h1021);
            #1;

            check_outputs(16'h1398, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("crc_generator Testbench");
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
        input [15:0] expected_crc_out;
        input expected_ready;
        begin
            if (expected_crc_out === (expected_crc_out ^ crc_out ^ expected_crc_out) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: crc_out=%h, ready=%b",
                         crc_out, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_out=%h, ready=%b",
                         expected_crc_out, expected_ready);
                $display("  Got:      crc_out=%h, ready=%b",
                         crc_out, ready);
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
        $dumpvars(0,clk, data_in, polynomial, reset, start, crc_out, ready);
    end

endmodule
