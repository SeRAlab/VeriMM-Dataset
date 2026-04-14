`timescale 1ns/1ps

module OFDM_Modulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    wire [15:0] ofdm_symbol;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    OFDM_Modulator dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .ofdm_symbol(ofdm_symbol)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("\nResetting the system...");
            rst = 1;
            data_in = 8'd0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Minimum valid input (0x00)", test_num);
            reset_dut();

            data_in = 8'h00;
            @(posedge clk);
            #1;



            #1;




            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum valid input (0xFF)", test_num);
            reset_dut();

            data_in = 8'hFF;
            @(posedge clk);
            #1;



            #1;




            check_outputs(16'h00FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mid-range value (0x80)", test_num);
            reset_dut();

            data_in = 8'h80;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0080);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating bit pattern (0xAA)", test_num);
            reset_dut();

            data_in = 8'hAA;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h00AA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Power of two input (0x40)", test_num);
            reset_dut();

            data_in = 8'h40;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0040);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("OFDM_Modulator Testbench");
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
        input [15:0] expected_ofdm_symbol;
        begin
            if (expected_ofdm_symbol === (expected_ofdm_symbol ^ ofdm_symbol ^ expected_ofdm_symbol)) begin
                $display("PASS");
                $display("  Outputs: ofdm_symbol=%h",
                         ofdm_symbol);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ofdm_symbol=%h",
                         expected_ofdm_symbol);
                $display("  Got:      ofdm_symbol=%h",
                         ofdm_symbol);
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
        $dumpvars(0,clk, data_in, rst, ofdm_symbol);
    end

endmodule
