`timescale 1ns/1ps

module deserializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg serial_in;
    wire [7:0] parallel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer dut (
        .clk(clk),
        .reset(reset),
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
            reset = 1;
            serial_in = 0;
            repeat(2) @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task send_byte;

        input [7:0] data;
        integer i;
        begin

            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = data[i];
                @(posedge clk);
                #1;
            end
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase 001: Alternating bits 10101010");
            reset_dut();
            send_byte(8'b10101010);
            #1;

            check_outputs(8'b10101010);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase 002: Alternating bits 01010101");
            reset_dut();
            send_byte(8'b01010101);
            #1;

            check_outputs(8'b01010101);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase 003: High nibble 11110000");
            reset_dut();
            send_byte(8'b11110000);
            #1;

            check_outputs(8'b11110000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase 004: All ones 11111111");
            reset_dut();
            send_byte(8'b11111111);
            #1;

            check_outputs(8'b11111111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase 005: All zeros 00000000");
            reset_dut();
            send_byte(8'b00000000);
            #1;

            check_outputs(8'b00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running Testcase 006: Random pattern 10100101");
            reset_dut();
            send_byte(8'b10100101);
            #1;

            check_outputs(8'b10100101);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deserializer Testbench");
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
        $dumpvars(0,clk, reset, serial_in, parallel_out);
    end

endmodule
