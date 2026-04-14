`timescale 1ns/1ps

module phase_shifter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] phase_select;
    reg rst;
    reg sig_in;
    wire sig_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_shifter dut (
        .clk(clk),
        .phase_select(phase_select),
        .rst(rst),
        .sig_in(sig_in),
        .sig_out(sig_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            phase_select = 2'b00;
            sig_in = 0;
            #20;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: 0 Degree Shift");
            reset_dut();
            test_num = 1;
            phase_select = 2'b00;
            sig_in = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: 90 Degree Shift");
            reset_dut();
            test_num = 2;
            phase_select = 2'b01;
            sig_in = 1;

            repeat(1) @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: 180 Degree Shift");
            reset_dut();
            test_num = 3;
            phase_select = 2'b10;
            sig_in = 1;

            repeat(1) @(posedge clk);
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: 270 Degree Shift");
            reset_dut();
            test_num = 4;
            phase_select = 2'b11;
            sig_in = 1;

            repeat(1) @(posedge clk);
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: 180 Degree Shift (Logic 0 transition)");
            reset_dut();
            test_num = 5;
            phase_select = 2'b10;


            sig_in = 1;
            @(posedge clk);
            sig_in = 0;


            repeat(1) @(posedge clk);
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Reset State Check");
            reset_dut();
            test_num = 6;
            sig_in = 1;
            rst = 1;
            #5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("phase_shifter Testbench");
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
        input expected_sig_out;
        begin
            if (expected_sig_out === (expected_sig_out ^ sig_out ^ expected_sig_out)) begin
                $display("PASS");
                $display("  Outputs: sig_out=%b",
                         sig_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sig_out=%b",
                         expected_sig_out);
                $display("  Got:      sig_out=%b",
                         sig_out);
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
        $dumpvars(0,clk, phase_select, rst, sig_in, sig_out);
    end

endmodule
