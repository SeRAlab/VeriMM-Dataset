`timescale 1ns/1ps

module ofdm_modulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    wire [3:0] symbol_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ofdm_modulator dut (
        .clk(clk),
        .data_in(data_in),
        .symbol_out(symbol_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in = 4'b0000;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running Testcase %03d: Data In = 4'h0", test_num);
            data_in = 4'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase %03d: Data In = 4'hA", test_num);
            data_in = 4'hA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase %03d: Data In = 4'h5", test_num);
            data_in = 4'h5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running Testcase %03d: Data In = 4'hF", test_num);
            data_in = 4'hF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Running Testcase %03d: Data In = 4'h9", test_num);
            data_in = 4'h9;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h9);
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
        input [3:0] expected_symbol_out;
        begin
            if (expected_symbol_out === (expected_symbol_out ^ symbol_out ^ expected_symbol_out)) begin
                $display("PASS");
                $display("  Outputs: symbol_out=%h",
                         symbol_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: symbol_out=%h",
                         expected_symbol_out);
                $display("  Got:      symbol_out=%h",
                         symbol_out);
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
        $dumpvars(0,clk, data_in, symbol_out);
    end

endmodule
