`timescale 1ns/1ps

module state_fsm_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg f;
    reg [2:0] p;
    wire P0;
    wire s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    state_fsm dut (
        .clk(clk),
        .f(f),
        .p(p),
        .P0(P0),
        .s(s)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: State p=000, f=0");

            p = 3'b000; f = 0;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: State p=000, f=1");
            p = 3'b000; f = 1;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: State p=001, f=0");
            p = 3'b001; f = 0;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: State p=001, f=1");
            p = 3'b001; f = 1;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: State p=010, f=0");
            p = 3'b010; f = 0;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: State p=010, f=1");
            p = 3'b010; f = 1;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: State p=011, f=0");
            p = 3'b011; f = 0;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: State p=011, f=1");
            p = 3'b011; f = 1;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case 009: State p=100, f=0");
            p = 3'b100; f = 0;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case 010: State p=100, f=1");
            p = 3'b100; f = 1;

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
        $display("state_fsm Testbench");
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
        input expected_P0;
        input expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P0 === (expected_P0 ^ P0 ^ expected_P0) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: P0=%b, s=%b",
                         P0, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P0=%b, s=%b",
                         expected_P0, expected_s);
                $display("  Got:      P0=%b, s=%b",
                         P0, s);
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
