`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bcd;
    wire [6:0] seven_seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bcd(bcd),
        .seven_seg(seven_seg)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            bcd = 4'b0000;
            $display("Test %0d: BCD = 0", test_num);
            #1;

            check_outputs(7'b1000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            bcd = 4'b0001;
            $display("Test %0d: BCD = 1", test_num);
            #1;

            check_outputs(7'b1111001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            bcd = 4'b0010;
            $display("Test %0d: BCD = 2", test_num);
            #1;

            check_outputs(7'b0100100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            bcd = 4'b0011;
            $display("Test %0d: BCD = 3", test_num);
            #1;

            check_outputs(7'b0110000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            bcd = 4'b0100;
            $display("Test %0d: BCD = 4", test_num);
            #1;

            check_outputs(7'b0011001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            bcd = 4'b0101;
            $display("Test %0d: BCD = 5", test_num);
            #1;

            check_outputs(7'b0010010);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            bcd = 4'b0110;
            $display("Test %0d: BCD = 6", test_num);
            #1;

            check_outputs(7'b0000010);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            bcd = 4'b0111;
            $display("Test %0d: BCD = 7", test_num);
            #1;

            check_outputs(7'b1111000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            bcd = 4'b1000;
            $display("Test %0d: BCD = 8", test_num);
            #1;

            check_outputs(7'b0000000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            bcd = 4'b1001;
            $display("Test %0d: BCD = 9", test_num);
            #1;

            check_outputs(7'b0010000);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            bcd = 4'b1010;
            $display("Test %0d: BCD = 10 (A)", test_num);
            #1;

            check_outputs(7'b0001000);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            bcd = 4'b1011;
            $display("Test %0d: BCD = 11 (b)", test_num);
            #1;

            check_outputs(7'b0000011);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            bcd = 4'b1100;
            $display("Test %0d: BCD = 12 (C)", test_num);
            #1;

            check_outputs(7'b1000110);
        end
        endtask

    task testcase014;

        begin
            test_num = test_num + 1;
            bcd = 4'b1101;
            $display("Test %0d: BCD = 13 (d)", test_num);
            #1;

            check_outputs(7'b0100001);
        end
        endtask

    task testcase015;

        begin
            test_num = test_num + 1;
            bcd = 4'b1110;
            $display("Test %0d: BCD = 14 (E)", test_num);
            #1;

            check_outputs(7'b0000110);
        end
        endtask

    task testcase016;

        begin
            test_num = test_num + 1;
            bcd = 4'b1111;
            $display("Test %0d: BCD = 15 (F)", test_num);
            #1;

            check_outputs(7'b0001110);
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
        input [6:0] expected_seven_seg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_seven_seg === (expected_seven_seg ^ seven_seg ^ expected_seven_seg)) begin
                $display("PASS");
                $display("  Outputs: seven_seg=%h",
                         seven_seg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seven_seg=%h",
                         expected_seven_seg);
                $display("  Got:      seven_seg=%h",
                         seven_seg);
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
