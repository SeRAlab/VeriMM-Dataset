`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg clk;
    reg load;
    wire [63:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .load(load),
        .C(C)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;
            load = 0;
            repeat (5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Multiplication (0 x 0)", test_num);
            reset_dut();
            A = 32'h0000_0000;
            B = 32'h0000_0000;
            load = 1;
            @(posedge clk);
            load = 0;

            repeat (10) @(posedge clk);
            #1;

            check_outputs(64'h0000_0000_0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Values (FFFFFFFF x FFFFFFFF)", test_num);
            reset_dut();
            A = 32'hFFFF_FFFF;
            B = 32'hFFFF_FFFF;
            load = 1;
            @(posedge clk);
            load = 0;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(64'hFFFF_FFFE_0000_0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identity (12345678 x 1)", test_num);
            reset_dut();
            A = 32'h1234_5678;
            B = 32'h0000_0001;
            load = 1;
            @(posedge clk);
            load = 0;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(64'h0000_0000_1234_5678);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power of 2 (80000000 x 2)", test_num);
            reset_dut();
            A = 32'h8000_0000;
            B = 32'h0000_0002;
            load = 1;
            @(posedge clk);
            load = 0;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(64'h0000_0001_0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Segment Interaction (1234 x 5678)", test_num);
            reset_dut();
            A = 32'h0000_1234;
            B = 32'h0000_5678;
            load = 1;
            @(posedge clk);
            load = 0;
            repeat (10) @(posedge clk);

            #1;


            check_outputs(64'h0000_0000_0626_0060);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large Mixed (ABCD0000 x 1234)", test_num);
            reset_dut();
            A = 32'hABCD_0000;
            B = 32'h0000_1234;
            load = 1;
            @(posedge clk);
            load = 0;
            repeat (10) @(posedge clk);

            #1;


            check_outputs(64'h0000_00C2_B644_0000);
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
        input [63:0] expected_C;
        begin
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
        $dumpvars(0,A, B, clk, load, C);
    end

endmodule
