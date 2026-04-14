`timescale 1ns/1ps

module ofdm_modulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [3:0] symbol_in;
    wire [15:0] modulated_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ofdm_modulator dut (
        .clk(clk),
        .rst(rst),
        .symbol_in(symbol_in),
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
            symbol_in = 4'b0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Running testcase001: Symbol 4'h0");
            symbol_in = 4'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Running testcase002: Symbol 4'hF");
            symbol_in = 4'hF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h000F);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Running testcase003: Symbol 4'hA");
            symbol_in = 4'hA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h000A);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Running testcase004: Symbol 4'h5");
            symbol_in = 4'h5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0005);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Running testcase005: Symbol 4'h1");
            symbol_in = 4'h1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Running testcase006: Symbol 4'h8");
            symbol_in = 4'h8;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0008);
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
        input [15:0] expected_modulated_out;
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
        $dumpvars(0,clk, rst, symbol_in, modulated_out);
    end

endmodule
