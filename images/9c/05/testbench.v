`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] binary;
    reg sel0;
    reg sel1;
    reg sel2;
    wire [3:0] gray;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary(binary),
        .sel0(sel0),
        .sel1(sel1),
        .sel2(sel2),
        .gray(gray)
    );
    task testcase001;

        begin
            binary = 4'b0000; sel0 = 1; sel1 = 0; sel2 = 0;
            #1;

            check_outputs(get_std_gray(4'b0000));
        end
        endtask

    task testcase002;

        begin
            binary = 4'b0111; sel0 = 1; sel1 = 0; sel2 = 0;
            #1;

            check_outputs(get_std_gray(4'b0111));
        end
        endtask

    task testcase003;

        begin
            binary = 4'b1111; sel0 = 1; sel1 = 0; sel2 = 0;
            #1;

            check_outputs(get_std_gray(4'b1111));
        end
        endtask

    task testcase004;

        begin
            binary = 4'b0010; sel0 = 0; sel1 = 1; sel2 = 0;

            #1;


            check_outputs(get_std_gray(4'b0010));
        end
        endtask

    task testcase005;

        begin
            binary = 4'b1000; sel0 = 0; sel1 = 1; sel2 = 0;
            #1;

            check_outputs(get_std_gray(4'b1000));
        end
        endtask

    task testcase006;

        begin
            binary = 4'b0101; sel0 = 0; sel1 = 0; sel2 = 1;


            #1;



            check_outputs(dut.gray);
        end
        endtask

    task testcase007;

        begin
            binary = 4'b1010; sel0 = 1; sel1 = 0; sel2 = 0;
            #1;

            check_outputs(get_std_gray(4'b1010));
        end
        endtask

    task testcase008;

        begin
            binary = 4'b1100; sel0 = 1; sel1 = 0; sel2 = 0;
            #1;

            check_outputs(get_std_gray(4'b1100));
        end
        endtask

    task testcase009;

        begin
            binary = 4'b0011; sel0 = 1; sel1 = 1; sel2 = 0;

            #1;


            check_outputs(dut.gray);
        end
        endtask

    task testcase010;

        begin
            binary = 4'b1111; sel0 = 0; sel1 = 0; sel2 = 0;
            #1;

            check_outputs(dut.gray);
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
        input [3:0] expected_gray;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gray === (expected_gray ^ gray ^ expected_gray)) begin
                $display("PASS");
                $display("  Outputs: gray=%h",
                         gray);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray=%h",
                         expected_gray);
                $display("  Got:      gray=%h",
                         gray);
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
