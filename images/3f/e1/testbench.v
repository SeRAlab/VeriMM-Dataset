`timescale 1ns/1ps

module ofdm_modulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg data_valid;
    reg rst;
    wire [3:0] symbol_out;
    wire symbol_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ofdm_modulator dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .rst(rst),
        .symbol_out(symbol_out),
        .symbol_valid(symbol_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 4'b0;
            data_valid = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset state check");
            reset_dut();

            #1;


            check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Mapping 4'hA");
            reset_dut();
            data_in = 4'hA;
            data_valid = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Mapping 4'h5");
            reset_dut();
            data_in = 4'h5;
            data_valid = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h5, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Mapping 4'hF");
            reset_dut();
            data_in = 4'hF;
            data_valid = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Invalid data handling");
            reset_dut();
            data_in = 4'hC;
            data_valid = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(symbol_out, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Mapping 4'h0");
            reset_dut();
            data_in = 4'h0;
            data_valid = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Sequence of data");
            reset_dut();


            data_in = 4'h1;
            data_valid = 1'b1;
            @(posedge clk);


            #1 data_in = 4'h2;
            @(posedge clk);

            #1;

            #1;


            check_outputs(4'h2, 1'b1);
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
        testcase007();
        
        
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
        input expected_symbol_valid;
        begin
            if (expected_symbol_out === (expected_symbol_out ^ symbol_out ^ expected_symbol_out) &&
                expected_symbol_valid === (expected_symbol_valid ^ symbol_valid ^ expected_symbol_valid)) begin
                $display("PASS");
                $display("  Outputs: symbol_out=%h, symbol_valid=%b",
                         symbol_out, symbol_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: symbol_out=%h, symbol_valid=%b",
                         expected_symbol_out, expected_symbol_valid);
                $display("  Got:      symbol_out=%h, symbol_valid=%b",
                         symbol_out, symbol_valid);
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
        $dumpvars(0,clk, data_in, data_valid, rst, symbol_out, symbol_valid);
    end

endmodule
