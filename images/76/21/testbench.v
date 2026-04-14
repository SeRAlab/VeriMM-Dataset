`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg EN;
    reg I0;
    reg I1;
    reg I2;
    reg I3;
    reg I4;
    reg I5;
    reg I6;
    reg I7;
    reg [2:0] SEL;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EN(EN),
        .I0(I0),
        .I1(I1),
        .I2(I2),
        .I3(I3),
        .I4(I4),
        .I5(I5),
        .I6(I6),
        .I7(I7),
        .SEL(SEL),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: EN=0, all inputs high. Y should be 0.", test_num);
            EN = 0;
            I0=1; I1=1; I2=1; I3=1; I4=1; I5=1; I6=1; I7=1;
            SEL = 3'b000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: EN=1, SEL=0, I0=1. Y should be 1.", test_num);
            EN = 1;
            I0=1; I1=0; I2=0; I3=0; I4=0; I5=0; I6=0; I7=0;
            SEL = 3'b000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: EN=1, SEL=1, I1=1. Y should be 1.", test_num);
            EN = 1;
            I0=0; I1=1; I2=0; I3=0; I4=0; I5=0; I6=0; I7=0;
            SEL = 3'b001;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: EN=1, SEL=2, I2=1. Y should be 1.", test_num);
            EN = 1;
            I0=0; I1=0; I2=1; I3=0; I4=0; I5=0; I6=0; I7=0;
            SEL = 3'b010;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: EN=1, SEL=3, I3=1. Y should be 1.", test_num);
            EN = 1;
            I0=0; I1=0; I2=0; I3=1; I4=0; I5=0; I6=0; I7=0;
            SEL = 3'b011;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: EN=1, SEL=4, I4=1. Y should be 1.", test_num);
            EN = 1;
            I0=0; I1=0; I2=0; I3=0; I4=1; I5=0; I6=0; I7=0;
            SEL = 3'b100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: EN=1, SEL=5, I5=1. Y should be 1.", test_num);
            EN = 1;
            I0=0; I1=0; I2=0; I3=0; I4=0; I5=1; I6=0; I7=0;
            SEL = 3'b101;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: EN=1, SEL=6, I6=1. Y should be 1.", test_num);
            EN = 1;
            I0=0; I1=0; I2=0; I3=0; I4=0; I5=0; I6=1; I7=0;
            SEL = 3'b110;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: EN=1, SEL=7, I7=1. Y should be 1.", test_num);
            EN = 1;
            I0=0; I1=0; I2=0; I3=0; I4=0; I5=0; I6=0; I7=1;
            SEL = 3'b111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: EN=1, SEL=3, I3=0, others=1. Y should be 0.", test_num);
            EN = 1;
            I0=1; I1=1; I2=1; I3=0; I4=1; I5=1; I6=1; I7=1;
            SEL = 3'b011;
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
