`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLR_n;
    reg CP;
    reg [3:0] D;
    reg LD_n;
    reg M;
    wire [3:0] Q;
    wire Qcc_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLR_n(CLR_n),
        .CP(CP),
        .D(D),
        .LD_n(LD_n),
        .M(M),
        .Q(Q),
        .Qcc_n(Qcc_n)
    );

    // Clock generation (10ns period)
    initial begin
        CP = 0;
        forever #5 CP = ~CP;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            $display("--- Testcase %03d Starting ---", test_num);
            CLR_n = 0;
            LD_n = 1;
            M = 0;
            D = 4'b0000;
            @(posedge CP);
            #1;
            CLR_n = 1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(4'h0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            LD_n = 0;
            D = 4'hA;
            @(posedge CP);
            #1;
            LD_n = 1;

            #1;


            check_outputs(4'hA, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            M = 1;
            repeat(5) @(posedge CP);
            #1;

            #1;


            check_outputs(4'h5, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            LD_n = 0; D = 4'h3;
            @(posedge CP); #1;
            LD_n = 1;
            M = 0;
            repeat(3) @(posedge CP);
            #1;

            #1;


            check_outputs(4'h3, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            LD_n = 0; D = 4'hF;
            @(posedge CP); #1;
            LD_n = 1; M = 1;
            @(posedge CP); #1;

            #1;


            check_outputs(4'h0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            LD_n = 0; D = 4'h7;
            @(posedge CP); #1;
            LD_n = 1; M = 1;
            @(posedge CP); #1;

            #1;


            check_outputs(4'h8, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            LD_n = 0; D = 4'h5;
            M = 1;
            CLR_n = 0;
            @(posedge CP); #1;

            #1;


            check_outputs(4'h0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            LD_n = 0; D = 4'hC;
            M = 1;
            @(posedge CP); #1;

            #1;


            check_outputs(4'hC, 1'b0);
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
        input [3:0] expected_Q;
        input expected_Qcc_n;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Qcc_n === (expected_Qcc_n ^ Qcc_n ^ expected_Qcc_n)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, Qcc_n=%b",
                         Q, Qcc_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, Qcc_n=%b",
                         expected_Q, expected_Qcc_n);
                $display("  Got:      Q=%h, Qcc_n=%b",
                         Q, Qcc_n);
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
        $dumpvars(0,CLR_n, CP, D, LD_n, M, Q, Qcc_n);
    end

endmodule
