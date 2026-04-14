`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] IN0;
    reg [3:0] IN1;
    reg [3:0] IN2;
    reg [3:0] IN3;
    reg [1:0] SEL;
    wire F;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IN0(IN0),
        .IN1(IN1),
        .IN2(IN2),
        .IN3(IN3),
        .SEL(SEL),
        .F(F)
    );
    task testcase001;

        begin
            test_num = 1;
            IN0 = 4'b0000;
            IN1 = 4'b1111;
            IN2 = 4'b1111;
            IN3 = 4'b1111;
            SEL = 2'b00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            IN0 = 4'b0001;
            IN1 = 4'b0000;
            IN2 = 4'b0000;
            IN3 = 4'b0000;
            SEL = 2'b00;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            IN0 = 4'b1111;
            IN1 = 4'b0000;
            IN2 = 4'b1111;
            IN3 = 4'b1111;
            SEL = 2'b01;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            IN0 = 4'b0000;
            IN1 = 4'b0001;
            IN2 = 4'b0000;
            IN3 = 4'b0000;
            SEL = 2'b01;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            IN0 = 4'b1111;
            IN1 = 4'b1111;
            IN2 = 4'b0000;
            IN3 = 4'b1111;
            SEL = 2'b10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            IN0 = 4'b0000;
            IN1 = 4'b0000;
            IN2 = 4'b0001;
            IN3 = 4'b0000;
            SEL = 2'b10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            IN0 = 4'b1111;
            IN1 = 4'b1111;
            IN2 = 4'b1111;
            IN3 = 4'b0000;
            SEL = 2'b11;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            IN0 = 4'b0000;
            IN1 = 4'b0000;
            IN2 = 4'b0000;
            IN3 = 4'b0001;
            SEL = 2'b11;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            IN0 = 4'b0000;
            IN1 = 4'b0000;
            IN2 = 4'b0000;
            IN3 = 4'b0000;
            SEL = 2'bxx;
            #1;

            check_outputs(1'bx);
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
        input expected_F;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_F === (expected_F ^ F ^ expected_F)) begin
                $display("PASS");
                $display("  Outputs: F=%b",
                         F);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: F=%b",
                         expected_F);
                $display("  Got:      F=%b",
                         F);
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
