`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [17:0] A;
    reg [17:0] B;
    reg C;
    reg CE;
    reg R;
    wire [35:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .CE(CE),
        .R(R),
        .P(P)
    );

    // Clock generation (10ns period)
    initial begin
        C = 0;
        forever #5 C = ~C;
    end

        task reset_dut;

    begin
        R = 1;
        CE = 1;
        A = 18'd0;
        B = 18'd0;
        @(posedge C);
        #1 R = 0;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        A = 18'sd100;
        B = 18'sd200;
        @(posedge C);
        #1 #1;
 check_outputs(36'sd20000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        A = 18'sd50;
        B = -18'sd40;
        @(posedge C);
        #1 #1;
 check_outputs(-36'sd2000);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        A = -18'sd30;
        B = -18'sd70;
        @(posedge C);
        #1 #1;
 check_outputs(36'sd2100);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        A = 18'sd12345;
        B = 18'sd0;
        @(posedge C);
        #1 #1;
 check_outputs(36'sd0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        A = 18'sd131071;
        B = 18'sd131071;
        @(posedge C);
        #1 #1;
 check_outputs(36'sd17179607041);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        A = -18'sd131072;
        B = -18'sd131072;
        @(posedge C);
        #1 #1;
 check_outputs(36'sd17179869184);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        A = -18'sd131072;
        B = 18'sd131071;
        @(posedge C);
        #1 #1;
 check_outputs(-36'sd17179738112);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        A = 18'sd10;
        B = 18'sd10;
        R = 1;
        @(posedge C);
        #1 #1;
 check_outputs(36'sd0);
        R = 0;
    end
        endtask

    task testcase009;

    begin
        reset_dut();

        A = 18'sd5;
        B = 18'sd5;
        @(posedge C);
        #1;

        CE = 0;
        A = 18'sd10;
        B = 18'sd10;
        @(posedge C);
        #1;

        #1;


        check_outputs(36'sd25);
        CE = 1;
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
        testcase009();
        
        
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
        input [35:0] expected_P;
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
        $dumpvars(0,A, B, C, CE, R, P);
    end

endmodule
