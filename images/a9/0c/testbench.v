`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] Pid;
    reg Pset;
    reg Pz;
    reg [1:0] X;
    reg [1:0] Y;
    reg [1:0] Z;
    reg rst;
    reg rw;
    wire Pval;
    wire Px;
    wire Py;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Pid(Pid),
        .Pset(Pset),
        .Pz(Pz),
        .X(X),
        .Y(Y),
        .Z(Z),
        .rst(rst),
        .rw(rw),
        .Pval(Pval),
        .Px(Px),
        .Py(Py)
    );
    task testcase001;

        begin
            $display("Testcase 001: Initial state check after reset");
            test_num = 1;

            rst = 1; rw = 0; X = 0; Y = 0; Z = 0; Pz = 0; Pset = 0; Pid = 0;
            #10;
            rst = 0;
            #10;


            X = 2'd0; Y = 2'd1; Pset = 1'b1; Pid = 2'd2;
            #5;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Initial state check for registers 2 and 3");
            test_num = 2;
            rst = 1; rw = 0; X = 0; Y = 0; Z = 0; Pz = 0; Pset = 0; Pid = 0;
            #10;
            rst = 0;
            #10;

            X = 2'd2; Y = 2'd3; Pset = 1'b1; Pid = 2'd1;
            #5;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write high to register 2");
            test_num = 3;
            rst = 1; rw = 0; #10; rst = 0; #10;

            rw = 1'b1; Z = 2'd2; Pz = 1'b1;
            #10;
            rw = 1'b0;

            X = 2'd2; Y = 2'd0; Pset = 1'b1; Pid = 2'd2;
            #5;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Write low to register 0");
            test_num = 4;
            rst = 1; rw = 0; #10; rst = 0; #10;

            rw = 1'b1; Z = 2'd0; Pz = 1'b0;
            #10;
            rw = 1'b0;

            X = 2'd0; Y = 2'd3; Pset = 1'b1; Pid = 2'd0;
            #5;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Verify Pset=0 logic (Pval constant high)");
            test_num = 5;
            rst = 1; rw = 0; #10; rst = 0; #10;

            X = 2'd2; Y = 2'd3; Pset = 1'b0; Pid = 2'd2;
            #5;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Verify rw=0 prevents writing");
            test_num = 6;
            rst = 1; rw = 0; #10; rst = 0; #10;

            rw = 1'b0; Z = 2'd3; Pz = 1'b1;
            #10;

            X = 2'd3; Y = 2'd0; Pset = 1'b1; Pid = 2'd3;
            #5;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Sequential writes to multiple registers");
            test_num = 7;
            rst = 1; #10; rst = 0; #10;

            rw = 1; Z = 2'd2; Pz = 1; #10;
            rw = 1; Z = 2'd3; Pz = 1; #10;
            rw = 1; Z = 2'd0; Pz = 0; #10;
            rw = 0;

            X = 2'd2; Y = 2'd3; Pset = 1; Pid = 2'd0;
            #5;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
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
        input expected_Pval;
        input expected_Px;
        input expected_Py;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Pval === (expected_Pval ^ Pval ^ expected_Pval) &&
                expected_Px === (expected_Px ^ Px ^ expected_Px) &&
                expected_Py === (expected_Py ^ Py ^ expected_Py)) begin
                $display("PASS");
                $display("  Outputs: Pval=%b, Px=%b, Py=%b",
                         Pval, Px, Py);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Pval=%b, Px=%b, Py=%b",
                         expected_Pval, expected_Px, expected_Py);
                $display("  Got:      Pval=%b, Px=%b, Py=%b",
                         Pval, Px, Py);
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
