`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] rda;
    reg [31:0] rdb;
    wire [31:0] a;
    wire [31:0] b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rda(rda),
        .rdb(rdb),
        .a(a),
        .b(b)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rda = 32'b0;
            rdb = 32'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Loading", test_num);
            reset_dut();
            rda = 32'h12345678;
            rdb = 32'h87654321;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h12345678, 32'h87654321);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros and All Ones", test_num);
            reset_dut();
            rda = 32'h00000000;
            rdb = 32'hFFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000, 32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bit Patterns", test_num);
            reset_dut();
            rda = 32'hAAAAAAAA;
            rdb = 32'h55555555;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hAAAAAAAA, 32'h55555555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Hex Values", test_num);
            reset_dut();
            rda = 32'hDEADBEEF;
            rdb = 32'hCAFEBABE;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hDEADBEEF, 32'hCAFEBABE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Rapid Sequential Change", test_num);
            reset_dut();

            rda = 32'h00001111;
            rdb = 32'hFFFFEEEE;
            @(posedge clk);
            #2;

            rda = 32'hBBBBCCCC;
            rdb = 32'h11112222;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hBBBBCCCC, 32'h11112222);
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
        input [31:0] expected_a;
        input [31:0] expected_b;
        begin
            if (expected_a === (expected_a ^ a ^ expected_a) &&
                expected_b === (expected_b ^ b ^ expected_b)) begin
                $display("PASS");
                $display("  Outputs: a=%h, b=%h",
                         a, b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a=%h, b=%h",
                         expected_a, expected_b);
                $display("  Got:      a=%h, b=%h",
                         a, b);
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
        $dumpvars(0,clk, rda, rdb, a, b);
    end

endmodule
