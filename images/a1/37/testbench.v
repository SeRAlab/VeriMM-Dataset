`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    wire [7:0] R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en(en),
        .R(R)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en <= 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Single cycle enable...", test_num);
            reset_dut();
            en <= 1;
            @(posedge clk);
            en <= 0;
            @(posedge clk);

            #1;


            check_outputs(R);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Multiple cycle enable (5 cycles)...", test_num);
            reset_dut();
            en <= 1;
            repeat(5) @(posedge clk);
            en <= 0;
            @(posedge clk);

            #1;


            check_outputs(R);
        end
        endtask

    task testcase003;

        reg [7:0] captured_val;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Stability check (en=0)...", test_num);
            reset_dut();


            en <= 1;
            @(posedge clk);
            en <= 0;
            @(posedge clk);
            captured_val = R;


            repeat(10) @(posedge clk);


            #1;



            check_outputs(captured_val);
        end
        endtask

    task testcase004;

        reg [7:0] val_before_disable;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Enable-Disable-Enable sequence...", test_num);
            reset_dut();

            en <= 1;
            repeat(2) @(posedge clk);
            en <= 0;
            @(posedge clk);
            val_before_disable = R;

            repeat(3) @(posedge clk);

            en <= 1;
            @(posedge clk);
            en <= 0;
            @(posedge clk);


            #1;



            check_outputs(R);
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
        input [7:0] expected_R;
        begin
            if (expected_R === (expected_R ^ R ^ expected_R)) begin
                $display("PASS");
                $display("  Outputs: R=%h",
                         R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: R=%h",
                         expected_R);
                $display("  Got:      R=%h",
                         R);
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
        $dumpvars(0,clk, en, R);
    end

endmodule
