`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] control;
    reg [15:0] data;
    reg rst_n;
    wire [15:0] R0;
    wire [15:0] R1;
    wire [15:0] R2;
    wire [15:0] R3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .control(control),
        .data(data),
        .rst_n(rst_n),
        .R0(R0),
        .R1(R1),
        .R2(R2),
        .R3(R3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            control = 16'h0;
            data = 16'h0;
            @(posedge clk);
            #1;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Load External Data to R0", test_num);
            reset_dut();
            data = 16'hA5A5;
            control = 16'h0001;
            @(posedge clk);
            #1;
            control = 16'h0000;
            #1;

            check_outputs(16'hA5A5, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Sequential Load All", test_num);
            reset_dut();


            data = 16'h1111; control = 16'h0001; @(posedge clk); #1;

            data = 16'h2222; control = 16'h0002; @(posedge clk); #1;

            data = 16'h3333; control = 16'h0004; @(posedge clk); #1;

            data = 16'h4444; control = 16'h0008; @(posedge clk); #1;

            control = 16'h0000;
            #1;

            check_outputs(16'h1111, 16'h2222, 16'h3333, 16'h4444);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Hold State Verification", test_num);
            reset_dut();


            data = 16'hFFFF; control = 16'h0001; @(posedge clk); #1;


            data = 16'h0000; control = 16'h0000;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Inter-Register Transfer", test_num);
            reset_dut();


            data = 16'hC0DE; control = 16'h0001; @(posedge clk); #1;


            control = 16'h0020; @(posedge clk); #1;


            control = 16'h0040; @(posedge clk); #1;


            control = 16'h0080; @(posedge clk); #1;

            control = 16'h0000;
            #1;

            check_outputs(16'hC0DE, 16'hC0DE, 16'hC0DE, 16'hC0DE);
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
        input [15:0] expected_R0;
        input [15:0] expected_R1;
        input [15:0] expected_R2;
        input [15:0] expected_R3;
        begin
            if (expected_R0 === (expected_R0 ^ R0 ^ expected_R0) &&
                expected_R1 === (expected_R1 ^ R1 ^ expected_R1) &&
                expected_R2 === (expected_R2 ^ R2 ^ expected_R2) &&
                expected_R3 === (expected_R3 ^ R3 ^ expected_R3)) begin
                $display("PASS");
                $display("  Outputs: R0=%h, R1=%h, R2=%h, R3=%h",
                         R0, R1, R2, R3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: R0=%h, R1=%h, R2=%h, R3=%h",
                         expected_R0, expected_R1, expected_R2, expected_R3);
                $display("  Got:      R0=%h, R1=%h, R2=%h, R3=%h",
                         R0, R1, R2, R3);
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
        $dumpvars(0,clk, control, data, rst_n, R0, R1, R2, R3);
    end

endmodule
