`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] N;
    reg clk;
    reg ldN;
    reg rst;
    wire [7:0] O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .N(N),
        .clk(clk),
        .ldN(ldN),
        .rst(rst),
        .O(O)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ldN = 0;
            N = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Synchronous Reset Check", test_num);
            reset_dut();


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Load Functionality (All 1s)", test_num);
            reset_dut();
            ldN = 1;
            N = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Load Functionality (Alternating bits)", test_num);
            reset_dut();
            ldN = 1;
            N = 8'hAA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Data Retention (ldN=0)", test_num);
            reset_dut();

            ldN = 1;
            N = 8'h55;
            @(posedge clk);
            #1;

            ldN = 0;
            N = 8'hFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Reset Priority Over Load", test_num);
            reset_dut();

            rst = 1;
            ldN = 1;
            N = 8'hCC;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Successive Loads", test_num);
            reset_dut();
            ldN = 1;
            N = 8'h10;
            @(posedge clk);
            #1;
            N = 8'h20;
            @(posedge clk);
            #1;
            N = 8'h30;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h30);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Verify No Change on N when ldN=0", test_num);
            reset_dut();
            ldN = 1;
            N = 8'hBE;
            @(posedge clk);
            #1;
            ldN = 0;
            N = 8'hEF;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hBE);
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
        testcase007();
        
        
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
        input [7:0] expected_O;
        begin
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%h",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%h",
                         expected_O);
                $display("  Got:      O=%h",
                         O);
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
        $dumpvars(0,N, clk, ldN, rst, O);
    end

endmodule
