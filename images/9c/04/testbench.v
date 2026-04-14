`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [3:0] inBus;
    reg [1:0] rdReg;
    reg rw;
    reg [1:0] wtReg;
    wire [3:0] outBus;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .inBus(inBus),
        .rdReg(rdReg),
        .rw(rw),
        .wtReg(wtReg),
        .outBus(outBus)
    );
    task testcase001;

        begin
            test_num = test_num + 1;

            enable = 0; rw = 0; inBus = 0; wtReg = 0; rdReg = 0;
            #10;

            rw = 1; enable = 1; wtReg = 2'b00; inBus = 4'hA;
            #10;

            rw = 0; rdReg = 2'b00;
            #10;
            $display("Test Case %0d: Basic Write/Read Reg0", test_num);
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;

            enable = 0; rw = 0; inBus = 0; wtReg = 0; rdReg = 0;
            #10;

            rw = 1; enable = 1; wtReg = 2'b11; inBus = 4'h5;
            #10;

            rw = 0; rdReg = 2'b11;
            #10;
            $display("Test Case %0d: Basic Write/Read Reg3", test_num);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;

            rw = 1; enable = 1; wtReg = 2'b01; inBus = 4'h7;
            #10;

            enable = 0; rw = 1; wtReg = 2'b01; inBus = 4'hF;
            #10;

            rw = 0; rdReg = 2'b01;
            #10;
            $display("Test Case %0d: Verify Enable=0 prevents writing", test_num);
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;

            rw = 1; enable = 1; wtReg = 2'b10; inBus = 4'h2;
            #10;

            rw = 0; enable = 1; wtReg = 2'b10; inBus = 4'hC;
            #10;

            rdReg = 2'b10;
            #10;
            $display("Test Case %0d: Verify rw=0 prevents writing", test_num);
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;

            enable = 0; rw = 0;
            #10;

            rw = 1; enable = 1; wtReg = 2'b00; inBus = 4'h1; #10;

            rw = 1; enable = 1; wtReg = 2'b00; inBus = 4'hE; #10;

            rw = 0; rdReg = 2'b00;
            #10;
            $display("Test Case %0d: Overwrite Reg0", test_num);
            #1;

            check_outputs(4'hE);
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
        input [3:0] expected_outBus;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outBus === (expected_outBus ^ outBus ^ expected_outBus)) begin
                $display("PASS");
                $display("  Outputs: outBus=%h",
                         outBus);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outBus=%h",
                         expected_outBus);
                $display("  Got:      outBus=%h",
                         outBus);
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

endmodule
