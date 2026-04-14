`timescale 1ns/1ps

module ofdm_modulator_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] bit_in;
    reg clk;
    reg reset;
    reg valid_in;
    wire [15:0] subcarrier_out_imag;
    wire [15:0] subcarrier_out_real;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ofdm_modulator dut (
        .bit_in(bit_in),
        .clk(clk),
        .reset(reset),
        .valid_in(valid_in),
        .subcarrier_out_imag(subcarrier_out_imag),
        .subcarrier_out_real(subcarrier_out_real),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            bit_in = 2'b00;
            valid_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            bit_in = 2'b00;
            valid_in = 1'b1;
            @(posedge clk);
            valid_in = 1'b0;
            @(posedge clk);
            #1;

            check_outputs(16'h7FFF, 16'h7FFF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            bit_in = 2'b01;
            valid_in = 1'b1;
            @(posedge clk);
            valid_in = 1'b0;
            @(posedge clk);
            #1;

            check_outputs(16'h7FFF, 16'h8001, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            bit_in = 2'b11;
            valid_in = 1'b1;
            @(posedge clk);
            valid_in = 1'b0;
            @(posedge clk);
            #1;

            check_outputs(16'h8001, 16'h8001, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            bit_in = 2'b10;
            valid_in = 1'b1;
            @(posedge clk);
            valid_in = 1'b0;
            @(posedge clk);
            #1;

            check_outputs(16'h8001, 16'h7FFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            bit_in = 2'b00;
            valid_in = 1'b0;
            @(posedge clk);
            @(posedge clk);

            #1;


            check_outputs(subcarrier_out_imag, subcarrier_out_real, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            bit_in = 2'b00;
            valid_in = 1'b1;
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            #1;

            check_outputs(subcarrier_out_imag, subcarrier_out_real, 1'b0);
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
        input [15:0] expected_subcarrier_out_imag;
        input [15:0] expected_subcarrier_out_real;
        input expected_valid_out;
        begin
            if (expected_subcarrier_out_imag === (expected_subcarrier_out_imag ^ subcarrier_out_imag ^ expected_subcarrier_out_imag) &&
                expected_subcarrier_out_real === (expected_subcarrier_out_real ^ subcarrier_out_real ^ expected_subcarrier_out_real) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: subcarrier_out_imag=%h, subcarrier_out_real=%h, valid_out=%b",
                         subcarrier_out_imag, subcarrier_out_real, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: subcarrier_out_imag=%h, subcarrier_out_real=%h, valid_out=%b",
                         expected_subcarrier_out_imag, expected_subcarrier_out_real, expected_valid_out);
                $display("  Got:      subcarrier_out_imag=%h, subcarrier_out_real=%h, valid_out=%b",
                         subcarrier_out_imag, subcarrier_out_real, valid_out);
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
        $dumpvars(0,bit_in, clk, reset, valid_in, subcarrier_out_imag, subcarrier_out_real, valid_out);
    end

endmodule
