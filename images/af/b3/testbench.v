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
            CE = 0;
            A = 0;
            B = 0;
            @(posedge C);
            #1;
            R = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 18'sd100;
            B = 18'sd200;
            CE = 1;
            @(posedge C);
            #1;
            #1;

            check_outputs(36'sd20000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 18'sd50;
            B = -18'sd30;
            CE = 1;
            @(posedge C);
            #1;
            #1;

            check_outputs(-36'sd1500);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = -18'sd10;
            B = -18'sd500;
            CE = 1;
            @(posedge C);
            #1;
            #1;

            check_outputs(36'sd5000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();

            A = 18'sd10;
            B = 18'sd10;
            CE = 1;
            @(posedge C);
            #1;


            A = 18'sd20;
            B = 18'sd20;
            CE = 0;
            @(posedge C);
            #1;

            #1;


            check_outputs(36'sd100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 18'sd0;
            B = 18'sh1FFFF;
            CE = 1;
            @(posedge C);
            #1;
            #1;

            check_outputs(36'sd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 18'sd131071;
            B = 18'sd2;
            CE = 1;
            @(posedge C);
            #1;
            #1;

            check_outputs(36'sd262142);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = -18'sd131072;
            B = 18'sd1;
            CE = 1;
            @(posedge C);
            #1;
            #1;

            check_outputs(-36'sd131072);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 18'sd50;
            B = 18'sd50;
            CE = 1;
            R = 1;
            @(posedge C);
            #1;
            #1;

            check_outputs(36'sd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = -18'sd1;
            B = -18'sd1;
            CE = 1;
            @(posedge C);
            #1;
            #1;

            check_outputs(36'sd1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = -18'sd131072;
            B = 18'sd131071;
            CE = 1;
            @(posedge C);
            #1;

            #1;


            check_outputs(-36'sd17179738112);
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
        testcase010();
        
        
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
