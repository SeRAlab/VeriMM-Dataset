`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in1;
    reg [15:0] in2;
    wire pgtn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .pgtn(pgtn)
    );
    task testcase001;

        begin
            test_num = 1;
            in1 = 16'h0000;
            in2 = 16'h0001;
            $display("Test %0d: in1=0, in2=1 (Expect pgtn=1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in1 = 16'h0001;
            in2 = 16'h0000;
            $display("Test %0d: in1=1, in2=0 (Expect pgtn=0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in1 = 16'h0000;
            in2 = 16'h0000;
            $display("Test %0d: in1=0, in2=0 (Expect pgtn=0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in1 = 16'hFFFE;
            in2 = 16'hFFFF;
            $display("Test %0d: in1=FFFFE, in2=FFFF (Expect pgtn=1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in1 = 16'hFFFF;
            in2 = 16'hFFFE;
            $display("Test %0d: in1=FFFF, in2=FFFE (Expect pgtn=0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in1 = 16'hFFFF;
            in2 = 16'hFFFF;
            $display("Test %0d: in1=FFFF, in2=FFFF (Expect pgtn=0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in1 = 16'h1234;
            in2 = 16'h5678;
            $display("Test %0d: in1=1234, in2=5678 (Expect pgtn=1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in1 = 16'hABCD;
            in2 = 16'h1234;
            $display("Test %0d: in1=ABCD, in2=1234 (Expect pgtn=0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            in1 = 16'h7FFF;
            in2 = 16'h8000;
            $display("Test %0d: in1=7FFF, in2=8000 (Expect pgtn=1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            in1 = 16'hAAAA;
            in2 = 16'hAAAB;
            $display("Test %0d: in1=AAAA, in2=AAAB (Expect pgtn=1)", test_num);
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
        input expected_pgtn;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pgtn === (expected_pgtn ^ pgtn ^ expected_pgtn)) begin
                $display("PASS");
                $display("  Outputs: pgtn=%b",
                         pgtn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pgtn=%b",
                         expected_pgtn);
                $display("  Got:      pgtn=%b",
                         pgtn);
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
