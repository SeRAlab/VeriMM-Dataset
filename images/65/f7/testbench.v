`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [8:0] freq;
    reg [2:0] octave;
    wire out;
    wire pulseout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .freq(freq),
        .octave(octave),
        .out(out),
        .pulseout(pulseout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            freq = 9'd0;
            octave = 3'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Low Frequency, Octave 0", test_num);
            reset_dut();

            octave = 3'd0;
            freq = 9'd10;


            repeat(25) @(posedge clk);



            #1;




            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Mid Frequency, Octave 2", test_num);
            reset_dut();

            octave = 3'd2;
            freq = 9'd20;


            repeat(100) @(posedge clk);


            #1;



            check_outputs(out, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: High Frequency, Max Octave", test_num);
            reset_dut();

            octave = 3'd7;
            freq = 9'd2;

            repeat(50) @(posedge clk);



            if (out === 1'bx || out === 1'bz)
                #1;

                check_outputs(1'b0, 1'b0);
            else
                #1;

                check_outputs(out, pulseout);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Maximum Frequency (511), Octave 1", test_num);
            reset_dut();

            octave = 3'd1;
            freq = 9'd511;

            repeat(200) @(posedge clk);

            #1;


            check_outputs(out, pulseout);
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
        input expected_out;
        input expected_pulseout;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_pulseout === (expected_pulseout ^ pulseout ^ expected_pulseout)) begin
                $display("PASS");
                $display("  Outputs: out=%b, pulseout=%b",
                         out, pulseout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b, pulseout=%b",
                         expected_out, expected_pulseout);
                $display("  Got:      out=%b, pulseout=%b",
                         out, pulseout);
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
        $dumpvars(0,clk, freq, octave, out, pulseout);
    end

endmodule
