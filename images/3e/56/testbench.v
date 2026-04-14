`timescale 1ns/1ps

module OFDM_Modulator_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] bitstream;
    reg clk;
    reg rst;
    wire [7:0] imag_out;
    wire [7:0] real_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    OFDM_Modulator dut (
        .bitstream(bitstream),
        .clk(clk),
        .rst(rst),
        .imag_out(imag_out),
        .real_out(real_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            bitstream = 8'h00;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Input 00", test_num);
            reset_dut();
            bitstream = 8'b00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01, 8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Input 01", test_num);
            reset_dut();
            bitstream = 8'b00000001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Input 10", test_num);
            reset_dut();
            bitstream = 8'b00000010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF, 8'h01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Input 11", test_num);
            reset_dut();
            bitstream = 8'b00000011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Input FF", test_num);
            reset_dut();
            bitstream = 8'hFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFF, 8'hFF);
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
        input [7:0] expected_imag_out;
        input [7:0] expected_real_out;
        begin
            if (expected_imag_out === (expected_imag_out ^ imag_out ^ expected_imag_out) &&
                expected_real_out === (expected_real_out ^ real_out ^ expected_real_out)) begin
                $display("PASS");
                $display("  Outputs: imag_out=%h, real_out=%h",
                         imag_out, real_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: imag_out=%h, real_out=%h",
                         expected_imag_out, expected_real_out);
                $display("  Got:      imag_out=%h, real_out=%h",
                         imag_out, real_out);
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
        $dumpvars(0,bitstream, clk, rst, imag_out, real_out);
    end

endmodule
