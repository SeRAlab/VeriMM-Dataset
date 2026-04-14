`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] A;
    reg [1:0] B;
    reg clk;
    wire CARRY;
    wire [3:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .CARRY(CARRY),
        .P(P)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 2'b00;
            B = 2'b00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: A=0, B=0", test_num);
            A = 2'd0; B = 2'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: A=1, B=1", test_num);
            A = 2'd1; B = 2'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: A=2, B=1", test_num);
            A = 2'd2; B = 2'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd2);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: A=3, B=1", test_num);
            A = 2'd3; B = 2'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd3);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: A=2, B=2", test_num);
            A = 2'd2; B = 2'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd4);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: A=3, B=2", test_num);
            A = 2'd3; B = 2'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd6);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: A=3, B=3", test_num);
            A = 2'd3; B = 2'd3;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 4'd9);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: A=0, B=3", test_num);
            A = 2'd0; B = 2'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd0);
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
        testcase008();
        
        
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
        input expected_CARRY;
        input [3:0] expected_P;
        begin
            if (expected_CARRY === (expected_CARRY ^ CARRY ^ expected_CARRY) &&
                expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: CARRY=%b, P=%h",
                         CARRY, P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CARRY=%b, P=%h",
                         expected_CARRY, expected_P);
                $display("  Got:      CARRY=%b, P=%h",
                         CARRY, P);
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
        $dumpvars(0,A, B, clk, CARRY, P);
    end

endmodule
