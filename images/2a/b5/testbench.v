`timescale 1ns/1ps

module ofdm_modulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg rst;
    wire [15:0] modulated_out;

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
            data_in = 4'b0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            data_in = 4'hA;

            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h000A);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            data_in = 4'h1; @(posedge clk); #1;
            data_in = 4'h2; @(posedge clk); #1;
            data_in = 4'h3; @(posedge clk); #1;
            data_in = 4'h4; @(posedge clk); #1;

            #1;


            check_outputs(16'h4321);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            data_in = 4'h1; @(posedge clk); #1;
            data_in = 4'h2; @(posedge clk); #1;
            data_in = 4'h3; @(posedge clk); #1;
            data_in = 4'h4; @(posedge clk); #1;
            data_in = 4'hF; @(posedge clk); #1;
            #1;

            check_outputs(16'h432F);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            data_in = 4'hF; @(posedge clk); #1;
            data_in = 4'hF; @(posedge clk); #1;
            data_in = 4'hF; @(posedge clk); #1;
            data_in = 4'hF; @(posedge clk); #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            data_in = 4'h5; @(posedge clk); #1;
            data_in = 4'h6; @(posedge clk); #1;
            rst = 1;        @(posedge clk); #1;
            #1;

            check_outputs(16'h0000);
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
        $dumpvars(0,clk, data_in, rst, modulated_out);
    end

endmodule
