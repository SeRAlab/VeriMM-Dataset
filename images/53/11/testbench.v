`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg clk;
    wire [91:0] spo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .clk(clk),
        .spo(spo)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 8'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Address 0x00", test_num);
            reset_dut();

            a = 8'h00;
            @(posedge clk);
            #2;



            #1;




            check_outputs(92'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Address 0x01", test_num);
            reset_dut();

            a = 8'h01;
            @(posedge clk);
            #2;


            #1;



            check_outputs(92'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Address 0x10", test_num);
            reset_dut();

            a = 8'h10;
            @(posedge clk);
            #2;

            #1;


            check_outputs(92'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Address 0x7F", test_num);
            reset_dut();

            a = 8'h7F;
            @(posedge clk);
            #2;

            #1;


            check_outputs(92'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Address 0xFF", test_num);
            reset_dut();

            a = 8'hFF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(92'h0);
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
        input [91:0] expected_spo;
        begin
            if (expected_spo === (expected_spo ^ spo ^ expected_spo)) begin
                $display("PASS");
                $display("  Outputs: spo=%h",
                         spo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: spo=%h",
                         expected_spo);
                $display("  Got:      spo=%h",
                         spo);
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
        $dumpvars(0,a, clk, spo);
    end

endmodule
