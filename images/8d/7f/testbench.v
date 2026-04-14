`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cs;
    reg nrst;
    reg sck;
    reg si;
    wire cs_s;
    wire sck_n;
    wire sck_p;
    wire si_s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .cs(cs),
        .nrst(nrst),
        .sck(sck),
        .si(si),
        .cs_s(cs_s),
        .sck_n(sck_n),
        .sck_p(sck_p),
        .si_s(si_s)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            nrst = 0;
            cs = 1;
            sck = 0;
            si = 0;
            repeat (5) @(posedge clk);
            nrst = 1;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();


            repeat (5) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: SI Synchronization", test_num);
            reset_dut();
            @(negedge clk);
            si = 1;

            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: CS Active Synchronization", test_num);
            reset_dut();
            @(negedge clk);
            cs = 0;

            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: SCK Rising Edge Detection", test_num);
            reset_dut();
            @(negedge clk);
            sck = 1;



            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: SCK Falling Edge Detection", test_num);
            reset_dut();
            @(negedge clk);
            sck = 1;
            repeat (5) @(posedge clk);
            @(negedge clk);
            sck = 0;

            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Combined Signals (CS=0, SI=1, SCK Rise)", test_num);
            reset_dut();
            @(negedge clk);
            cs = 0;
            si = 1;
            repeat (5) @(posedge clk);
            @(negedge clk);
            sck = 1;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
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
        input expected_cs_s;
        input expected_sck_n;
        input expected_sck_p;
        input expected_si_s;
        begin
            if (expected_cs_s === (expected_cs_s ^ cs_s ^ expected_cs_s) &&
                expected_sck_n === (expected_sck_n ^ sck_n ^ expected_sck_n) &&
                expected_sck_p === (expected_sck_p ^ sck_p ^ expected_sck_p) &&
                expected_si_s === (expected_si_s ^ si_s ^ expected_si_s)) begin
                $display("PASS");
                $display("  Outputs: cs_s=%b, sck_n=%b, sck_p=%b, si_s=%b",
                         cs_s, sck_n, sck_p, si_s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cs_s=%b, sck_n=%b, sck_p=%b, si_s=%b",
                         expected_cs_s, expected_sck_n, expected_sck_p, expected_si_s);
                $display("  Got:      cs_s=%b, sck_n=%b, sck_p=%b, si_s=%b",
                         cs_s, sck_n, sck_p, si_s);
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
        $dumpvars(0,clk, cs, nrst, sck, si, cs_s, sck_n, sck_p, si_s);
    end

endmodule
