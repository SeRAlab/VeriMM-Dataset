`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] dr;
    reg [15:0] dr_in;
    reg rst;
    reg [2:0] sr1;
    reg [2:0] sr2;
    reg take_data;
    wire [15:0] sr1_out;
    wire [15:0] sr2_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dr(dr),
        .dr_in(dr_in),
        .rst(rst),
        .sr1(sr1),
        .sr2(sr2),
        .take_data(take_data),
        .sr1_out(sr1_out),
        .sr2_out(sr2_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            take_data = 0;
            dr = 0;
            dr_in = 0;
            sr1 = 0;
            sr2 = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset verification", test_num);
            reset_dut();


            sr1 = 0;
            sr2 = 7;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single register write and read", test_num);
            reset_dut();


            @(posedge clk);
            take_data = 1;
            dr = 3;
            dr_in = 16'hABCD;


            @(posedge clk);
            take_data = 0;
            sr1 = 3;
            sr2 = 0;


            @(posedge clk);
            #1 #1;
 check_outputs(16'hABCD, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple register writes", test_num);
            reset_dut();


            @(posedge clk);
            take_data = 1; dr = 1; dr_in = 16'h1111;
            @(posedge clk);

            dr = 2; dr_in = 16'h2222;
            @(posedge clk);
            take_data = 0;


            sr1 = 1;
            sr2 = 2;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h1111, 16'h2222);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write enable (take_data) check", test_num);
            reset_dut();


            @(posedge clk);
            take_data = 0;
            dr = 5;
            dr_in = 16'hFFFF;

            @(posedge clk);
            sr1 = 5;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overwrite register", test_num);
            reset_dut();


            @(posedge clk);
            take_data = 1; dr = 4; dr_in = 16'hAAAA;
            @(posedge clk);

            dr = 4; dr_in = 16'h5555;
            @(posedge clk);
            take_data = 0;
            sr1 = 4;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h5555, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary register addresses (0 and 7)", test_num);
            reset_dut();


            @(posedge clk);
            take_data = 1; dr = 0; dr_in = 16'h0001;
            @(posedge clk);

            dr = 7; dr_in = 16'h8000;
            @(posedge clk);
            take_data = 0;
            sr1 = 0;
            sr2 = 7;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0001, 16'h8000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset priority over write", test_num);
            reset_dut();


            @(posedge clk);
            rst = 1;
            take_data = 1;
            dr = 1;
            dr_in = 16'hEEEE;
            @(posedge clk);
            rst = 0;
            take_data = 0;
            sr1 = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0000, 16'h0000);
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
        input [15:0] expected_sr1_out;
        input [15:0] expected_sr2_out;
        begin
            if (expected_sr1_out === (expected_sr1_out ^ sr1_out ^ expected_sr1_out) &&
                expected_sr2_out === (expected_sr2_out ^ sr2_out ^ expected_sr2_out)) begin
                $display("PASS");
                $display("  Outputs: sr1_out=%h, sr2_out=%h",
                         sr1_out, sr2_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sr1_out=%h, sr2_out=%h",
                         expected_sr1_out, expected_sr2_out);
                $display("  Got:      sr1_out=%h, sr2_out=%h",
                         sr1_out, sr2_out);
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
        $dumpvars(0,clk, dr, dr_in, rst, sr1, sr2, take_data, sr1_out, sr2_out);
    end

endmodule
