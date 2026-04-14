`timescale 1ns/1ps

module ofdm_modulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg rst;
    wire [7:0] modulated_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ofdm_modulator dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .modulated_out(modulated_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 4'b0000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case 001: Input 4'b0000");
            data_in = 4'b0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b00000000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case 002: Input 4'b1111");
            data_in = 4'b1111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b11111111);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case 003: Input 4'b1010");
            data_in = 4'b1010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b11001100);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case 004: Input 4'b0101");
            data_in = 4'b0101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b00110011);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case 005: Input 4'b1100");
            data_in = 4'b1100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b11110000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case 006: Input 4'b0001");
            data_in = 4'b0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b00000011);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ofdm_modulator Testbench");
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
        input [7:0] expected_modulated_out;
        begin
            if (expected_modulated_out === (expected_modulated_out ^ modulated_out ^ expected_modulated_out)) begin
                $display("PASS");
                $display("  Outputs: modulated_out=%h",
                         modulated_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: modulated_out=%h",
                         expected_modulated_out);
                $display("  Got:      modulated_out=%h",
                         modulated_out);
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
        $dumpvars(0,clk, data_in, rst, modulated_out);
    end

endmodule
