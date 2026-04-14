`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg L;
    reg clk;
    wire [7:0] B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .L(L),
        .clk(clk),
        .B(B)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        L = 0;
        A = 8'h00;

        repeat(5) @(negedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Load 4 cycles", test_num);
        reset_dut();

        @(negedge clk); L = 1; A = 8'h11;
        @(negedge clk); L = 1; A = 8'h22;
        @(negedge clk); L = 1; A = 8'h33;
        @(negedge clk); L = 1; A = 8'h44;

        @(posedge clk); #2;
        #1;

        check_outputs(8'h11);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Load 5 cycles", test_num);
        reset_dut();

        @(negedge clk); L = 1; A = 8'hAA;
        @(negedge clk); L = 1; A = 8'hBB;
        @(negedge clk); L = 1; A = 8'hCC;
        @(negedge clk); L = 1; A = 8'hDD;
        @(negedge clk); L = 1; A = 8'hEE;

        @(posedge clk); #2;
        #1;

        check_outputs(8'hBB);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset reg4 with L=0", test_num);
        reset_dut();


        @(negedge clk); L = 1; A = 8'h11;
        @(negedge clk); L = 1; A = 8'h22;
        @(negedge clk); L = 1; A = 8'h33;
        @(negedge clk); L = 1; A = 8'h44;


        @(negedge clk); L = 0;

        @(posedge clk); #2;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Left shift movement and Load Resume", test_num);
        reset_dut();


        @(negedge clk); L = 1; A = 8'h11;
        @(negedge clk); L = 1; A = 8'h22;
        @(negedge clk); L = 1; A = 8'h33;
        @(negedge clk); L = 1; A = 8'h44;



        @(negedge clk); L = 0;



        @(negedge clk); L = 1; A = 8'h99;

        @(posedge clk); #2;
        #1;

        check_outputs(8'h11);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: reg1 preservation check", test_num);
        reset_dut();


        @(negedge clk); L = 1; A = 8'hFF;


        @(negedge clk); L = 0;
        @(negedge clk); L = 0;
        @(negedge clk); L = 0;


        @(negedge clk); L = 1; A = 8'h00;
        @(negedge clk); L = 1; A = 8'h00;
        @(negedge clk); L = 1; A = 8'h00;

        @(posedge clk); #2;
        #1;

        check_outputs(8'hFF);
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
        input [7:0] expected_B;
        begin
            if (expected_B === (expected_B ^ B ^ expected_B)) begin
                $display("PASS");
                $display("  Outputs: B=%h",
                         B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B=%h",
                         expected_B);
                $display("  Got:      B=%h",
                         B);
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
        $dumpvars(0,A, L, clk, B);
    end

endmodule
