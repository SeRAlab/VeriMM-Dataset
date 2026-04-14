`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg BusyE;
    reg [31:0] InstrD;
    wire StartD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BusyE(BusyE),
        .InstrD(InstrD),
        .StartD(StartD)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: MULT instruction, BusyE=0", test_num);

            InstrD = 32'h0000_0018;
            BusyE = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: MULTU instruction, BusyE=0", test_num);

            InstrD = 32'h0000_0019;
            BusyE = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: DIV instruction, BusyE=0", test_num);

            InstrD = 32'h0000_001A;
            BusyE = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: DIVU instruction, BusyE=0", test_num);

            InstrD = 32'h0000_001B;
            BusyE = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: MULT instruction, BusyE=1 (Should be blocked)", test_num);
            InstrD = 32'h0000_0018;
            BusyE = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: DIV instruction, BusyE=1 (Should be blocked)", test_num);
            InstrD = 32'h0000_001A;
            BusyE = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Non-mult/div R-Type (ADD), BusyE=0", test_num);

            InstrD = 32'h0000_0020;
            BusyE = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: I-Type instruction (ADDI), BusyE=0", test_num);

            InstrD = 32'h2000_0000;
            BusyE = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: J-Type instruction (J), BusyE=0", test_num);

            InstrD = 32'h0800_0000;
            BusyE = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Funct bits similar to mult/div but not exact, BusyE=0", test_num);

            InstrD = 32'h0000_001C;
            BusyE = 1'b0;
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
        input expected_StartD;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_StartD === (expected_StartD ^ StartD ^ expected_StartD)) begin
                $display("PASS");
                $display("  Outputs: StartD=%b",
                         StartD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: StartD=%b",
                         expected_StartD);
                $display("  Got:      StartD=%b",
                         StartD);
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
