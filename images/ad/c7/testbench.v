`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Ck;
    reg Ckn;
    reg D;
    reg Rn;
    wire Q;
    wire Qn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Ck(Ck),
        .Ckn(Ckn),
        .D(D),
        .Rn(Rn),
        .Q(Q),
        .Qn(Qn)
    );

    // Clock generation (10ns period)
    initial begin
        Ck = 0;
        forever #5 Ck = ~Ck;
    end

        task reset_dut;

        begin
            Rn = 0;
            Ckn = 0;
            D = 0;
            #12;
            Rn = 1;
            @(negedge Ck);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Asynchronous Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Synchronous Load High (Enable=1, D=1)", test_num);
            reset_dut();
            @(negedge Ck);
            Ckn = 1; D = 1;
            @(posedge Ck);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Synchronous Load Low (Enable=1, D=0)", test_num);
            reset_dut();
            @(negedge Ck);
            Ckn = 1; D = 1;
            @(posedge Ck);
            #2;
            @(negedge Ck);
            Ckn = 1; D = 0;
            @(posedge Ck);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Enable Hold Functionality (Enable=0)", test_num);
            reset_dut();
            @(negedge Ck);
            Ckn = 1; D = 1;
            @(posedge Ck);
            #2;
            @(negedge Ck);
            Ckn = 0; D = 0;
            @(posedge Ck);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Asynchronous Reset Priority", test_num);
            reset_dut();
            @(negedge Ck);
            Ckn = 1; D = 1;
            @(posedge Ck);
            #2;
            Rn = 0;
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Ignore D changes when Enable is Low", test_num);
            reset_dut();
            @(negedge Ck);
            Ckn = 0; D = 1;
            @(posedge Ck);
            #2;
            @(negedge Ck);
            D = 0;
            @(posedge Ck);
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
        input expected_Qn;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Qn === (expected_Qn ^ Qn ^ expected_Qn)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Qn=%b",
                         Q, Qn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Qn=%b",
                         expected_Q, expected_Qn);
                $display("  Got:      Q=%b, Qn=%b",
                         Q, Qn);
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
        $dumpvars(0,Ck, Ckn, D, Rn, Q, Qn);
    end

endmodule
