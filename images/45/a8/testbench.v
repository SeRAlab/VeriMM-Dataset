`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] iAddress;
    wire [27:0] oInstruction;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iAddress(iAddress),
        .oInstruction(oInstruction)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Address 0x0000", test_num);
            iAddress = 16'h0000;

            #1;


            check_outputs(28'h0000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Address 0x0001", test_num);
            iAddress = 16'h0001;
            #1;

            check_outputs(28'h0000001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Address 0x0002", test_num);
            iAddress = 16'h0002;
            #1;

            check_outputs(28'h0000002);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Address 0x0003", test_num);
            iAddress = 16'h0003;
            #1;

            check_outputs(28'h0000003);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Address 0x0004", test_num);
            iAddress = 16'h0004;
            #1;

            check_outputs(28'h0000004);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Address 0x0005", test_num);
            iAddress = 16'h0005;
            #1;

            check_outputs(28'h0000005);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Address 0x0006", test_num);
            iAddress = 16'h0006;
            #1;

            check_outputs(28'h0000006);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Address 0x0007", test_num);
            iAddress = 16'h0007;
            #1;

            check_outputs(28'h0000007);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Address 0x0008", test_num);
            iAddress = 16'h0008;
            #1;

            check_outputs(28'h0000008);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Address 0x0009", test_num);
            iAddress = 16'h0009;
            #1;

            check_outputs(28'h0000009);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test Case %0d: Address 0x000A", test_num);
            iAddress = 16'h000A;
            #1;

            check_outputs(28'h000000A);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Test Case %0d: Address 0x000B", test_num);
            iAddress = 16'h000B;
            #1;

            check_outputs(28'h000000B);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            $display("Test Case %0d: Address 0x000C", test_num);
            iAddress = 16'h000C;
            #1;

            check_outputs(28'h000000C);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            $display("Test Case %0d: Address 0x000D", test_num);
            iAddress = 16'h000D;
            #1;

            check_outputs(28'h000000D);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            $display("Test Case %0d: Address 0x000E", test_num);
            iAddress = 16'h000E;
            #1;

            check_outputs(28'h000000E);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            $display("Test Case %0d: Address 0x000F", test_num);
            iAddress = 16'h000F;
            #1;

            check_outputs(28'h000000F);
        end
        endtask

    task testcase017;

        begin
            test_num = 17;
            $display("Test Case %0d: Out of bounds Address (0xFFFF)", test_num);
            iAddress = 16'hFFFF;


            #1;



            check_outputs(28'h0000000);
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
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        testcase017();
        
        
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
        input [27:0] expected_oInstruction;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oInstruction === (expected_oInstruction ^ oInstruction ^ expected_oInstruction)) begin
                $display("PASS");
                $display("  Outputs: oInstruction=%h",
                         oInstruction);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oInstruction=%h",
                         expected_oInstruction);
                $display("  Got:      oInstruction=%h",
                         oInstruction);
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
