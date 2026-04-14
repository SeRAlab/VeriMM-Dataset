`timescale 1ns/1ps

module crc_generator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg [2:0] poly;
    reg reset;
    wire [2:0] crc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc_generator dut (
        .clk(clk),
        .data_in(data_in),
        .poly(poly),
        .reset(reset),
        .crc_out(crc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in_reg = 4'b0000;
            poly = 3'b000;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            data_in_reg = 4'b1011;
            poly = 3'b011;
            repeat(8) @(posedge clk);
            $display("Test Case 001: Data=1011, Poly=011 (Divisor 1011)");
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data_in_reg = 4'b0000;
            poly = 3'b101;
            repeat(8) @(posedge clk);
            $display("Test Case 002: Data=0000, Poly=101");
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data_in_reg = 4'b1100;
            poly = 3'b011;
            repeat(8) @(posedge clk);
            $display("Test Case 003: Data=1100, Poly=011");
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data_in_reg = 4'b1000;
            poly = 3'b011;
            repeat(8) @(posedge clk);
            $display("Test Case 004: Data=1000, Poly=011");
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data_in_reg = 4'b1111;
            poly = 3'b111;
            repeat(8) @(posedge clk);
            $display("Test Case 005: Data=1111, Poly=111");
            #1;

            check_outputs(3'b000);
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
        input [2:0] expected_crc_out;
        begin
            if (expected_crc_out === (expected_crc_out ^ crc_out ^ expected_crc_out)) begin
                $display("PASS");
                $display("  Outputs: crc_out=%h",
                         crc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_out=%h",
                         expected_crc_out);
                $display("  Got:      crc_out=%h",
                         crc_out);
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
        $dumpvars(0,clk, data_in, poly, reset, crc_out);
    end

endmodule
