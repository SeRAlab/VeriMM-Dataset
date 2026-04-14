`timescale 1ns/1ps

module crc_generator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg data_valid;
    reg reset;
    wire [7:0] crc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc_generator dut (
        .clk(clk),
        .data(data),
        .data_valid(data_valid),
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
            data = 8'h00;
            data_valid = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            data = 8'h01;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;
            repeat(8) @(posedge clk);
            test_num = test_num + 1;
            $display("Test Case 001: Input 0x01");
            #1;

            check_outputs(8'h07);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            data = 8'hFF;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;
            repeat(8) @(posedge clk);
            test_num = test_num + 1;
            $display("Test Case 002: Input 0xFF");
            #1;

            check_outputs(8'hAC);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            data = 8'h00;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;
            repeat(8) @(posedge clk);
            test_num = test_num + 1;
            $display("Test Case 003: Input 0x00");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            data = 8'hAA;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;
            repeat(8) @(posedge clk);
            test_num = test_num + 1;
            $display("Test Case 004: Input 0xAA");
            #1;

            check_outputs(8'h1E);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            data = 8'h55;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;
            repeat(8) @(posedge clk);
            test_num = test_num + 1;
            $display("Test Case 005: Input 0x55");
            #1;

            check_outputs(8'h51);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            data = 8'h12;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;
            repeat(8) @(posedge clk);
            test_num = test_num + 1;
            $display("Test Case 006: Input 0x12");
            #1;

            check_outputs(8'h84);
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
        input [7:0] expected_crc_out;
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
        $dumpvars(0,clk, data, data_valid, reset, crc_out);
    end

endmodule
