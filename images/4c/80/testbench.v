`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire [3:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All zeros (match)", test_num);
            a = 4'b0000;
            b = 4'b0000;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: All ones (match)", test_num);
            a = 4'b1111;
            b = 4'b1111;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: All zeros vs all ones (total mismatch)", test_num);
            a = 4'b0000;
            b = 4'b1111;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Alternating bits (match)", test_num);
            a = 4'b1010;
            b = 4'b1010;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Alternating bits (total mismatch)", test_num);
            a = 4'b1010;
            b = 4'b0101;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Mixed pattern 1", test_num);
            a = 4'b1100;
            b = 4'b1010;

            #1;


            check_outputs(4'b1001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Mixed pattern 2", test_num);
            a = 4'b0110;
            b = 4'b0011;

            #1;


            check_outputs(4'b1010);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Single bit difference (LSB)", test_num);
            a = 4'b0001;
            b = 4'b0000;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Single bit difference (MSB)", test_num);
            a = 4'b1000;
            b = 4'b0000;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Inverse bit pattern", test_num);
            a = 4'b1110;
            b = 4'b0001;
            #1;

            check_outputs(4'b0000);
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
        input [3:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
