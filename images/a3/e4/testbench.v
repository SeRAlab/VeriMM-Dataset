`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg de_clk;
    reg rstn;
    reg tog_in;
    wire sig_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .de_clk(de_clk),
        .rstn(rstn),
        .tog_in(tog_in),
        .sig_out(sig_out)
    );

    // Clock generation (10ns period)
    initial begin
        de_clk = 0;
        forever #5 de_clk = ~de_clk;
    end

        task reset_dut;

        begin
            rstn = 0;
            tog_in = 0;
            #15;
            rstn = 1;
            @(posedge de_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running testcase%03d: 0 to 1 Transition detection", test_num);
            reset_dut();
            tog_in = 1;
            @(posedge de_clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running testcase%03d: Pulse termination after 0 to 1 transition", test_num);
            reset_dut();
            tog_in = 1;
            repeat(2) @(posedge de_clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running testcase%03d: 1 to 0 Transition detection", test_num);
            reset_dut();

            tog_in = 1;
            repeat(3) @(posedge de_clk);

            tog_in = 0;
            @(posedge de_clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running testcase%03d: Steady state check (no toggle)", test_num);
            reset_dut();
            tog_in = 0;
            repeat(5) @(posedge de_clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running testcase%03d: Consecutive toggles", test_num);
            reset_dut();
            tog_in = 1;
            @(posedge de_clk);

            tog_in = 0;
            @(posedge de_clk);
            #1;



            #1;




            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running testcase%03d: Reset impact during pulse", test_num);
            reset_dut();
            tog_in = 1;
            @(posedge de_clk);
            #1;

            rstn = 0;
            #2;
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
        $display("top_module Testbench");
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
        $dumpvars(0,de_clk, rstn, tog_in, sig_out);
    end

endmodule
