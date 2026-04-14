`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg direction;
    reg [31:0] i_in;
    reg [4:0] shift_amount;
    wire [31:0] rot_prod;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .direction(direction),
        .i_in(i_in),
        .shift_amount(shift_amount),
        .rot_prod(rot_prod)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Rotate Right by 0", test_num);
            i_in = 32'h12345678;
            direction = 0;
            shift_amount = 5'd0;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Rotate Right by 1", test_num);
            i_in = 32'h00000001;
            direction = 0;
            shift_amount = 5'd1;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Rotate Right by 16", test_num);
            i_in = 32'hDEADBEEF;
            direction = 0;
            shift_amount = 5'd16;
            #1;

            check_outputs(32'hBEEFDEAD);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Rotate Right by 31", test_num);
            i_in = 32'h00000001;
            direction = 0;
            shift_amount = 5'd31;
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Rotate Left by 0", test_num);
            i_in = 32'hF0F0F0F0;
            direction = 1;
            shift_amount = 5'd0;
            #1;

            check_outputs(32'hF0F0F0F0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Rotate Left by 1", test_num);
            i_in = 32'h80000000;
            direction = 1;
            shift_amount = 5'd1;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Rotate Left by 4", test_num);
            i_in = 32'h12345678;
            direction = 1;
            shift_amount = 5'd4;
            #1;

            check_outputs(32'h23456781);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Rotate Left by 31", test_num);
            i_in = 32'h00000001;
            direction = 1;
            shift_amount = 5'd31;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTestcase %0d: All Ones Pattern", test_num);
            i_in = 32'hFFFFFFFF;
            direction = 0;
            shift_amount = 5'd15;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("\nTestcase %0d: Alternating Bits Rotate Left 1", test_num);
            i_in = 32'h55555555;
            direction = 1;
            shift_amount = 5'd1;
            #1;

            check_outputs(32'hAAAAAAAA);
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
        input [31:0] expected_rot_prod;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rot_prod === (expected_rot_prod ^ rot_prod ^ expected_rot_prod)) begin
                $display("PASS");
                $display("  Outputs: rot_prod=%h",
                         rot_prod);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rot_prod=%h",
                         expected_rot_prod);
                $display("  Got:      rot_prod=%h",
                         rot_prod);
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
