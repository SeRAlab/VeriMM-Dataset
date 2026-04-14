`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg D;
    reg GATE_N;
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire Q;
    wire Q_N;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .GATE_N(GATE_N),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .Q(Q),
        .Q_N(Q_N)
    );

    // Clock generation (10ns period)
    initial begin
        GATE_N = 0;
        forever #5 GATE_N = ~GATE_N;
    end

        task reset_dut;

        begin
            D = 1'b0;
            VPWR = 1'b1;
            VGND = 1'b0;
            VPB = 1'b1;
            VNB = 1'b1;

            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Transparent Mode (D=1, GATE_N=0)", test_num);
            wait(GATE_N === 1'b0);
            D = 1'b1;
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Transparent Mode (D=0, GATE_N=0)", test_num);
            wait(GATE_N === 1'b0);
            D = 1'b0;
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Latch Mode (Capture 1, Change D while GATE_N=1)", test_num);
            wait(GATE_N === 1'b0);
            D = 1'b1;
            wait(GATE_N === 1'b1);
            D = 1'b0;
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Latch Mode (Capture 0, Change D while GATE_N=1)", test_num);
            wait(GATE_N === 1'b0);
            D = 1'b0;
            wait(GATE_N === 1'b1);
            D = 1'b1;
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: VPB Safety Override (VPB=0 forces Q=0)", test_num);
            VPB = 1'b0;
            D = 1'b1;
            wait(GATE_N === 1'b0);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %03d: VNB Safety Override (VNB=0 forces Q=1)", test_num);
            VNB = 1'b0;
            D = 1'b0;
            wait(GATE_N === 1'b0);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %03d: VPB Override triggering while GATE_N is High", test_num);
            wait(GATE_N === 1'b0);
            D = 1'b1;
            wait(GATE_N === 1'b1);
            VPB = 1'b0;
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_Q;
        input expected_Q_N;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Q_N === (expected_Q_N ^ Q_N ^ expected_Q_N)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Q_N=%b",
                         Q, Q_N);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Q_N=%b",
                         expected_Q, expected_Q_N);
                $display("  Got:      Q=%b, Q_N=%b",
                         Q, Q_N);
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
        $dumpvars(0,D, GATE_N, VGND, VNB, VPB, VPWR, Q, Q_N);
    end

endmodule
