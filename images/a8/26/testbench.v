`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
    reg EN;
    reg [1:0] SEL;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .EN(EN),
        .SEL(SEL),
        .Y(Y)
    );

    // Clock generation (10ns period)
    initial begin
        EN = 0;
        forever #5 EN = ~EN;
    end

        task reset_dut;

        begin
            A = 4'b0;
            B = 4'b0;
            C = 4'b0;
            D = 4'b0;
            SEL = 2'b0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: EN=0 Output Gating", test_num);

            A = 4'hf; B = 4'hf; C = 4'hf; D = 4'hf;
            SEL = 2'b00;
            wait(EN == 0);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, SEL=00 (A=1)", test_num);
            A = 4'hf; B = 4'h0; C = 4'h0; D = 4'h0;
            SEL = 2'b00;
            wait(EN == 1);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, SEL=00 (A=0)", test_num);
            A = 4'h0; B = 4'hf; C = 4'hf; D = 4'hf;
            SEL = 2'b00;
            wait(EN == 1);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, SEL=01 (B=1)", test_num);
            A = 4'h0; B = 4'hf; C = 4'h0; D = 4'h0;
            SEL = 2'b01;
            wait(EN == 1);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, SEL=10 (C=1)", test_num);
            A = 4'h0; B = 4'h0; C = 4'hf; D = 4'h0;
            SEL = 2'b10;
            wait(EN == 1);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, SEL=11 (D=1)", test_num);
            A = 4'h0; B = 4'h0; C = 4'h0; D = 4'hf;
            SEL = 2'b11;
            wait(EN == 1);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Input Isolation Test", test_num);
            A = 4'h0; B = 4'hf; C = 4'hf; D = 4'hf;
            SEL = 2'b00;
            wait(EN == 1);
            #2;
            #1;

            check_outputs(1'b0);
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
        input expected_Y;
        begin
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
        $dumpvars(0,A, B, C, D, EN, SEL, Y);
    end

endmodule
