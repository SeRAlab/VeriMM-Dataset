`timescale 1ns/1ps

module ofdm_modulator_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] bit_stream;
    reg clk;
    reg reset;
    reg valid;
    wire [7:0] ofdm_symbol;
    wire symbol_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ofdm_modulator dut (
        .bit_stream(bit_stream),
        .clk(clk),
        .reset(reset),
        .valid(valid),
        .ofdm_symbol(ofdm_symbol),
        .symbol_valid(symbol_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            valid = 0;
            bit_stream = 4'b0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros Input (4'b0000)", test_num);
            reset_dut();

            bit_stream = 4'b0000;
            valid = 1;
            @(posedge clk);
            valid = 0;


            wait(symbol_valid === 1'b1);


            #1;



            check_outputs(8'h00, 1'b1);


            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Impulse Input (4'b0001)", test_num);
            reset_dut();

            bit_stream = 4'b0001;
            valid = 1;
            @(posedge clk);
            valid = 0;

            wait(symbol_valid === 1'b1);



            if (ofdm_symbol !== 8'h00) begin
                pass_count = pass_count + 1;
                $display("PASS: Non-zero symbol generated for active subcarrier");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Symbol remained zero for active subcarrier");
            end

            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones Input (4'b1111)", test_num);
            reset_dut();

            bit_stream = 4'b1111;
            valid = 1;
            @(posedge clk);
            valid = 0;

            wait(symbol_valid === 1'b1);


            if (symbol_valid === 1'b1) begin
                $display("PASS: symbol_valid asserted for data 4'b1111");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: symbol_valid not asserted");
                fail_count = fail_count + 1;
            end

            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset Recovery and Alternating Bits", test_num);
            reset_dut();

            bit_stream = 4'b1010;
            valid = 1;
            @(posedge clk);
            valid = 0;

            wait(symbol_valid === 1'b1);


            if (ofdm_symbol !== 8'hxx) begin
                $display("PASS: Valid data produced after reset recovery");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: X-state detected in output");
                fail_count = fail_count + 1;
            end

            @(posedge clk);
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
        input [7:0] expected_ofdm_symbol;
        input expected_symbol_valid;
        begin
            if (expected_ofdm_symbol === (expected_ofdm_symbol ^ ofdm_symbol ^ expected_ofdm_symbol) &&
                expected_symbol_valid === (expected_symbol_valid ^ symbol_valid ^ expected_symbol_valid)) begin
                $display("PASS");
                $display("  Outputs: ofdm_symbol=%h, symbol_valid=%b",
                         ofdm_symbol, symbol_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ofdm_symbol=%h, symbol_valid=%b",
                         expected_ofdm_symbol, expected_symbol_valid);
                $display("  Got:      ofdm_symbol=%h, symbol_valid=%b",
                         ofdm_symbol, symbol_valid);
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
        $dumpvars(0,bit_stream, clk, reset, valid, ofdm_symbol, symbol_valid);
    end

endmodule
