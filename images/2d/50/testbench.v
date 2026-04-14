`timescale 1ns/1ps

module ofdm_modulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg reset;
    wire [7:0] ofdm_symbol;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ofdm_modulator dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .ofdm_symbol(ofdm_symbol),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        data_in = 4'b0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Running Testcase 001: Input 4'b0000 (SC1=0, SC2=0)");
        reset_dut();
        data_in = 4'b0000;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h00, 1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Running Testcase 002: Input 4'b0001 (SC1=180, SC2=0)");
        reset_dut();
        data_in = 4'b0001;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h10, 1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Running Testcase 003: Input 4'b0010 (SC1=0, SC2=180)");
        reset_dut();
        data_in = 4'b0010;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h01, 1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("Running Testcase 004: Input 4'b0011 (SC1=180, SC2=180)");
        reset_dut();
        data_in = 4'b0011;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h11, 1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Running Testcase 005: Input 4'b1100 (Check if upper bits impact SC1/2)");
        reset_dut();
        data_in = 4'b1100;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h00, 1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("Running Testcase 006: Multiple blocks sequentially");
        reset_dut();


        data_in = 4'b0001;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h10, 1'b1);


        data_in = 4'b0010;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h01, 1'b1);
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
        input [7:0] expected_ofdm_symbol;
        input expected_valid;
        begin
            if (expected_ofdm_symbol === (expected_ofdm_symbol ^ ofdm_symbol ^ expected_ofdm_symbol) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: ofdm_symbol=%h, valid=%b",
                         ofdm_symbol, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ofdm_symbol=%h, valid=%b",
                         expected_ofdm_symbol, expected_valid);
                $display("  Got:      ofdm_symbol=%h, valid=%b",
                         ofdm_symbol, valid);
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
        $dumpvars(0,clk, data_in, reset, ofdm_symbol, valid);
    end

endmodule
