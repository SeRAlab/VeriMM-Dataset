`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] iC;
    reg iS0;
    reg iS1;
    reg iS2;
    wire oZ;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iC(iC),
        .iS0(iS0),
        .iS1(iS1),
        .iS2(iS2),
        .oZ(oZ)
    );
    task testcase001;

        begin
            test_num = 1;
            iC = 8'b00000001;
            iS2 = 0; iS1 = 0; iS0 = 0;
            $display("Test %0d: Select bit 0, iC=8'h01, S=000", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            iC = 8'b00000010;
            iS2 = 0; iS1 = 0; iS0 = 1;
            $display("Test %0d: Select bit 1, iC=8'h02, S=001", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            iC = 8'b00000100;
            iS2 = 0; iS1 = 1; iS0 = 0;
            $display("Test %0d: Select bit 2, iC=8'h04, S=010", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            iC = 8'b00001000;
            iS2 = 0; iS1 = 1; iS0 = 1;
            $display("Test %0d: Select bit 3, iC=8'h08, S=011", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            iC = 8'b00010000;
            iS2 = 1; iS1 = 0; iS0 = 0;
            $display("Test %0d: Select bit 4, iC=8'h10, S=100", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            iC = 8'b00100000;
            iS2 = 1; iS1 = 0; iS0 = 1;
            $display("Test %0d: Select bit 5, iC=8'h20, S=101", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            iC = 8'b01000000;
            iS2 = 1; iS1 = 1; iS0 = 0;
            $display("Test %0d: Select bit 6, iC=8'h40, S=110", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            iC = 8'b10000000;
            iS2 = 1; iS1 = 1; iS0 = 1;
            $display("Test %0d: Select bit 7, iC=8'h80, S=111", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            iC = 8'b11111110;
            iS2 = 0; iS1 = 0; iS0 = 0;
            $display("Test %0d: Select bit 0, iC=8'hFE, S=000", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            iC = 8'b10101010;
            iS2 = 0; iS1 = 1; iS0 = 1;
            $display("Test %0d: Select bit 3, iC=8'hAA, S=011", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            iC = 8'b10101010;
            iS2 = 1; iS1 = 0; iS0 = 0;
            $display("Test %0d: Select bit 4, iC=8'hAA, S=100", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            iC = 8'b01010101;
            iS2 = 1; iS1 = 1; iS0 = 1;
            $display("Test %0d: Select bit 7, iC=8'h55, S=111", test_num);
            #1;

            check_outputs(0);
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
        testcase011();
        testcase012();
        
        
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
        input expected_oZ;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oZ === (expected_oZ ^ oZ ^ expected_oZ)) begin
                $display("PASS");
                $display("  Outputs: oZ=%b",
                         oZ);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oZ=%b",
                         expected_oZ);
                $display("  Got:      oZ=%b",
                         oZ);
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
