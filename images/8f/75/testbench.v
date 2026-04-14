`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] SUBSEQ;
    wire [22:0] SUBSEQ_BUS;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SUBSEQ(SUBSEQ),
        .SUBSEQ_BUS(SUBSEQ_BUS)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input SUBSEQ = 0", test_num);
            SUBSEQ = 8'd0;

            #1;


            check_outputs(23'h000001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input SUBSEQ = 1", test_num);
            SUBSEQ = 8'd1;

            #1;


            check_outputs(23'h000002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input SUBSEQ = 5", test_num);
            SUBSEQ = 8'd5;

            #1;


            check_outputs(23'h000020);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input SUBSEQ = 10", test_num);
            SUBSEQ = 8'd10;

            #1;


            check_outputs(23'h000400);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input SUBSEQ = 16", test_num);
            SUBSEQ = 8'd16;

            #1;


            check_outputs(23'h010000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input SUBSEQ = 22 (Upper Boundary)", test_num);
            SUBSEQ = 8'd22;

            #1;


            check_outputs(23'h400000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input SUBSEQ = 23 (Out of range)", test_num);
            SUBSEQ = 8'd23;

            #1;


            check_outputs(23'h000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input SUBSEQ = 255 (Max Value)", test_num);
            SUBSEQ = 8'd255;

            #1;


            check_outputs(23'h000000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input SUBSEQ = 12", test_num);
            SUBSEQ = 8'd12;

            #1;


            check_outputs(23'h001000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input SUBSEQ = 21", test_num);
            SUBSEQ = 8'd21;

            #1;


            check_outputs(23'h200000);
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
        input [22:0] expected_SUBSEQ_BUS;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_SUBSEQ_BUS === (expected_SUBSEQ_BUS ^ SUBSEQ_BUS ^ expected_SUBSEQ_BUS)) begin
                $display("PASS");
                $display("  Outputs: SUBSEQ_BUS=%h",
                         SUBSEQ_BUS);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SUBSEQ_BUS=%h",
                         expected_SUBSEQ_BUS);
                $display("  Got:      SUBSEQ_BUS=%h",
                         SUBSEQ_BUS);
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
