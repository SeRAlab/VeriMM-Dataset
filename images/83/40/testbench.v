`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg FS;
    reg Phi;
    reg [1:0] Res;
    reg notFS;
    wire notShiftCount1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .FS(FS),
        .Phi(Phi),
        .Res(Res),
        .notFS(notFS),
        .notShiftCount1(notShiftCount1)
    );

        task reset_dut;

        begin
            FS = 0;
            notFS = 1;
            Res = 2'b00;
            @(negedge Phi);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Load 2'b11", test_num);


            FS = 1;
            notFS = 0;
            Res = 2'b11;
            @(posedge Phi);
            #1;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Load 2'b01", test_num);


            FS = 1;
            notFS = 0;
            Res = 2'b01;
            @(posedge Phi);
            #1;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Load 2'b11 and Decrement once", test_num);


            FS = 1;
            notFS = 0;
            Res = 2'b11;
            @(posedge Phi);


            FS = 0;
            notFS = 1;
            @(posedge Phi);
            #1;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Load 2'b10 and Decrement once", test_num);


            FS = 1;
            notFS = 0;
            Res = 2'b10;
            @(posedge Phi);


            FS = 0;
            notFS = 1;
            @(posedge Phi);
            #1;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Load 2'b01 and Decrement once", test_num);


            FS = 1;
            notFS = 0;
            Res = 2'b01;
            @(posedge Phi);


            FS = 0;
            notFS = 1;
            @(posedge Phi);
            #1;


            #1;



            check_outputs(1'b1);
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
        input expected_notShiftCount1;
        begin
            if (expected_notShiftCount1 === (expected_notShiftCount1 ^ notShiftCount1 ^ expected_notShiftCount1)) begin
                $display("PASS");
                $display("  Outputs: notShiftCount1=%b",
                         notShiftCount1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: notShiftCount1=%b",
                         expected_notShiftCount1);
                $display("  Got:      notShiftCount1=%b",
                         notShiftCount1);
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
        $dumpvars(0,FS, Phi, Res, notFS, notShiftCount1);
    end

endmodule
