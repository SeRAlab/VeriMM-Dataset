`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg CLK;
    reg LD;
    reg RST;
    reg SEL;
    reg UD;
    wire [3:0] C;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CLK(CLK),
        .LD(LD),
        .RST(RST),
        .SEL(SEL),
        .UD(UD),
        .C(C),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            UD = 0;
            LD = 0;
            SEL = 0;
            A = 0;
            B = 0;
            @(posedge CLK);
            #1 RST = 0;
            @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'sd3;
            B = 4'sd2;
            UD = 1;
            SEL = 0;
            LD = 1;
            @(posedge CLK);
            @(posedge CLK);
            #1 #1;
 check_outputs(4'h0, 4'h2);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'sd7;
            B = -4'sd2;
            UD = 1;
            SEL = 1;
            LD = 1;
            @(posedge CLK);
            @(posedge CLK);
            #1 #1;
 check_outputs(4'hF, 4'h7);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = -4'sd4;
            B = -4'sd4;
            UD = 1;
            SEL = 1;
            LD = 1;
            @(posedge CLK);
            @(posedge CLK);
            #1 #1;
 check_outputs(4'h1, 4'hc);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'sd2;
            B = 4'sd2;
            UD = 0;
            SEL = 0;
            LD = 1;
            @(posedge CLK);
            @(posedge CLK);
            @(posedge CLK);
            #1 #1;
 check_outputs(4'h0, 4'hD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = -4'sd8;
            B = 4'sd7;
            UD = 1;
            SEL = 1;
            LD = 1;
            @(posedge CLK);
            @(posedge CLK);
            #1 #1;
 check_outputs(4'hC, 4'h8);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'sd5;
            B = 4'sd0;
            UD = 1;
            SEL = 0;
            LD = 1;
            @(posedge CLK);
            @(posedge CLK);
            #1 #1;
 check_outputs(4'h0, 4'h2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'sd7;
            B = 4'sd7;
            UD = 0;
            SEL = 1;
            LD = 1;
            @(posedge CLK);
            @(posedge CLK);
            #1 #1;
 check_outputs(4'h3, 4'h7);
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
        input [3:0] expected_C;
        input [3:0] expected_Q;
        begin
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: C=%h, Q=%h",
                         C, Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h, Q=%h",
                         expected_C, expected_Q);
                $display("  Got:      C=%h, Q=%h",
                         C, Q);
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
        $dumpvars(0,A, B, CLK, LD, RST, SEL, UD, C, Q);
    end

endmodule
