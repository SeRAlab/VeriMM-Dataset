`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ReadData1;
    reg [31:0] ReadData2;
    wire EqualD;
    wire LtzD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ReadData1(ReadData1),
        .ReadData2(ReadData2),
        .EqualD(EqualD),
        .LtzD(LtzD)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ReadData1 = 0, ReadData2 = 0 (Equal)", test_num);
            ReadData1 = 32'h00000000;
            ReadData2 = 32'h00000000;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ReadData1 = MAX, ReadData2 = MAX (Equal)", test_num);
            ReadData1 = 32'hFFFFFFFF;
            ReadData2 = 32'hFFFFFFFF;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ReadData1 = 10, ReadData2 = 20 (Less Than)", test_num);
            ReadData1 = 32'd10;
            ReadData2 = 32'd20;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ReadData1 = 20, ReadData2 = 10 (Greater Than)", test_num);
            ReadData1 = 32'd20;
            ReadData2 = 32'd10;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ReadData1 = 7FFFFFFF, ReadData2 = 80000000 (Less Than)", test_num);
            ReadData1 = 32'h7FFFFFFF;
            ReadData2 = 32'h80000000;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ReadData1 = 80000000, ReadData2 = 7FFFFFFF (Greater Than)", test_num);
            ReadData1 = 32'h80000000;
            ReadData2 = 32'h7FFFFFFF;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ReadData1 = A, ReadData2 = A+1 (Less Than)", test_num);
            ReadData1 = 32'hABCDE000;
            ReadData2 = 32'hABCDE001;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ReadData1 = 1, ReadData2 = 0 (Greater Than)", test_num);
            ReadData1 = 32'd1;
            ReadData2 = 32'd0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ReadData1 = deadbeef, ReadData2 = f0000000 (Less Than)", test_num);
            ReadData1 = 32'hDEADBEEF;
            ReadData2 = 32'hF0000000;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ReadData1 = fffffffe, ReadData2 = 00000001 (Greater Than)", test_num);
            ReadData1 = 32'hFFFFFFFE;
            ReadData2 = 32'h00000001;
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_EqualD;
        input expected_LtzD;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EqualD === (expected_EqualD ^ EqualD ^ expected_EqualD) &&
                expected_LtzD === (expected_LtzD ^ LtzD ^ expected_LtzD)) begin
                $display("PASS");
                $display("  Outputs: EqualD=%b, LtzD=%b",
                         EqualD, LtzD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EqualD=%b, LtzD=%b",
                         expected_EqualD, expected_LtzD);
                $display("  Got:      EqualD=%b, LtzD=%b",
                         EqualD, LtzD);
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
