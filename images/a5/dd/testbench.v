`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A1;
    reg A2;
    reg A3;
    reg A4;
    reg B1;
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .A4(A4),
        .B1(B1),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .X(X)
    );

    // Clock generation (10ns period)
    initial begin
        VGND = 0;
        forever #5 VGND = ~VGND;
    end

        task reset_dut;

        begin
            A1 = 0;
            A2 = 0;
            A3 = 0;
            A4 = 0;
            B1 = 0;
            VPWR = 0;
            VPB = 1;
            VNB = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: All High inputs, Trigger VPWR", test_num);
            A1 = 1; A2 = 1; A3 = 1; A4 = 1; B1 = 1;
            #5;
            VPWR = 1;
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: All Low inputs, Trigger VPWR", test_num);
            A1 = 0; A2 = 0; A3 = 0; A4 = 0; B1 = 0;
            #5;
            VPWR = 1;
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: Mixed inputs (B1=0), Trigger VPWR", test_num);
            A1 = 1; A2 = 1; A3 = 1; A4 = 1; B1 = 0;
            #5;
            VPWR = 1;
            #2;
            #1;

            check_outputs(1'bx);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: All High inputs, Trigger VGND falling", test_num);
            A1 = 1; A2 = 1; A3 = 1; A4 = 1; B1 = 1;
            VPWR = 1;
            @(negedge VGND);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: All Low inputs, Trigger VGND falling", test_num);
            A1 = 0; A2 = 0; A3 = 0; A4 = 0; B1 = 0;
            VPWR = 1;
            @(negedge VGND);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %0d: Mixed inputs (A1=1, others=0), Trigger VGND falling", test_num);
            A1 = 1; A2 = 0; A3 = 0; A4 = 0; B1 = 0;
            VPWR = 1;
            @(negedge VGND);
            #2;
            #1;

            check_outputs(1'bx);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test %0d: Mixed inputs (A4=0), Trigger VPWR", test_num);
            A1 = 1; A2 = 1; A3 = 1; A4 = 0; B1 = 1;
            #5;
            VPWR = 1;
            #2;
            #1;

            check_outputs(1'bx);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Test %0d: Input change without edge trigger", test_num);


            A1 = 0; A2 = 0; A3 = 0; A4 = 0; B1 = 0;
            #5; VPWR = 1; #2;


            A1 = 1; A2 = 1; A3 = 1; A4 = 1; B1 = 1;
            #1;

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
        input expected_X;
        begin
            if (expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: X=%b",
                         X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%b",
                         expected_X);
                $display("  Got:      X=%b",
                         X);
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
        $dumpvars(0,A1, A2, A3, A4, B1, VGND, VNB, VPB, VPWR, X);
    end

endmodule
