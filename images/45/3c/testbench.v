`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [3:0] B;
    wire [11:0] RES;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .RES(RES)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            A = 8'd0;
            B = 4'd0;
            #1;

            check_outputs(12'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max A, Zero B", test_num);
            A = 8'd255;
            B = 4'd0;
            #1;

            check_outputs(12'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero A, Max B", test_num);
            A = 8'd0;
            B = 4'd15;
            #1;

            check_outputs(12'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identity (1x1)", test_num);
            A = 8'd1;
            B = 4'd1;
            #1;

            check_outputs(12'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max A, Identity B", test_num);
            A = 8'd255;
            B = 4'd1;
            #1;

            check_outputs(12'd255);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identity A, Max B", test_num);
            A = 8'd1;
            B = 4'd15;
            #1;

            check_outputs(12'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Values (255 x 15)", test_num);
            A = 8'd255;
            B = 4'd15;
            #1;

            check_outputs(12'd3825);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power of Two", test_num);
            A = 8'd128;
            B = 4'd8;
            #1;

            check_outputs(12'd1024);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits", test_num);
            A = 8'b10101010;
            B = 4'b1010;
            #1;

            check_outputs(12'd1700);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random Prime-ish Multiplication", test_num);
            A = 8'd123;
            B = 4'd11;
            #1;

            check_outputs(12'd1353);
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
        input [11:0] expected_RES;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RES === (expected_RES ^ RES ^ expected_RES)) begin
                $display("PASS");
                $display("  Outputs: RES=%h",
                         RES);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RES=%h",
                         expected_RES);
                $display("  Got:      RES=%h",
                         RES);
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
