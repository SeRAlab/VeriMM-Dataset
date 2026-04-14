`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] A;
    reg [3:0] B;
    reg S;
    reg clk;
    wire [15:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .S(S),
        .clk(clk),
        .P(P)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 16'h0;
            B = 4'h0;
            S = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            A = 16'hABCD;
            B = 4'd0;
            S = 1'b0;
            @(posedge clk);
            #2;
            $display("Test %0d: No shift (B=0, S=0)", test_num);
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            A = 16'h000F;
            B = 4'd4;
            S = 1'b0;
            @(posedge clk);
            #2;
            $display("Test %0d: Left shift 4 bits", test_num);
            #1;

            check_outputs(16'h00F0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            A = 16'hF000;
            B = 4'd4;
            S = 1'b0;
            @(posedge clk);
            #2;
            $display("Test %0d: Left shift out MSBs", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            A = 16'h4000;
            B = 4'd2;
            S = 1'b1;
            @(posedge clk);
            #2;
            $display("Test %0d: Right shift arithmetic (Positive MSB)", test_num);
            #1;

            check_outputs(16'h1000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            A = 16'h8000;
            B = 4'd4;
            S = 1'b1;
            @(posedge clk);
            #2;
            $display("Test %0d: Right shift arithmetic (Negative MSB - Sign extension)", test_num);
            #1;

            check_outputs(16'hF800);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            A = 16'hFFFF;
            B = 4'd15;
            S = 1'b1;
            @(posedge clk);
            #2;
            $display("Test %0d: Right shift arithmetic (Full sign extension)", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            A = 16'h1234;
            B = 4'd0;
            S = 1'b1;
            @(posedge clk);
            #2;
            $display("Test %0d: No shift (B=0, S=1)", test_num);
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            A = 16'hAAAA;
            B = 4'd1;
            S = 1'b0;
            @(posedge clk);
            #2;
            $display("Test %0d: Left shift 1 bit", test_num);
            #1;

            check_outputs(16'h5554);
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
        input [15:0] expected_P;
        begin
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
        $dumpvars(0,A, B, S, clk, P);
    end

endmodule
