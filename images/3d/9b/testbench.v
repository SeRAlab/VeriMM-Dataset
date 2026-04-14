`timescale 1ns/1ps

module phase_shifter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] phase_control;
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
        .phase_control(phase_control),
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
            phase_control = 0;
            sig_in = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Shift by 1 cycle");
            reset_dut();
            phase_control = 3'd1;


            sig_in = 1;
            @(posedge clk);
            sig_in = 0;


            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Shift by 3 cycles");
            reset_dut();
            phase_control = 3'd3;


            sig_in = 1;
            @(posedge clk);
            sig_in = 0;
            repeat(2) @(posedge clk);


            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Shift by 7 cycles (Max)");
            reset_dut();
            phase_control = 3'd7;


            sig_in = 1;
            @(posedge clk);
            sig_in = 0;
            repeat(6) @(posedge clk);


            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Shift by 0 cycles (Bypass)");
            reset_dut();
            phase_control = 3'd0;

            sig_in = 1;


            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Constant signal shift by 4");
            reset_dut();
            phase_control = 3'd4;

            sig_in = 1;
            repeat(5) @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Zero input validation");
            reset_dut();
            phase_control = 3'd2;

            sig_in = 0;
            repeat(5) @(posedge clk);

            #1;
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
        $dumpvars(0,clk, phase_control, rst, sig_in, sig_out);
    end

endmodule
