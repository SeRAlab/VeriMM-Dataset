`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] D;
    reg [3:0] shift_ctrl;
    wire [15:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .shift_ctrl(shift_ctrl),
        .Q(Q)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: No shift (shift_ctrl = 0)", test_num);
        D = 16'hAAAA;
        shift_ctrl = 4'd0;
        #10;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Logical shift left by 1", test_num);
        D = 16'h0001;
        shift_ctrl = 4'd1;
        #10;
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Logical shift left by 4 (nibble shift)", test_num);
        D = 16'h000F;
        shift_ctrl = 4'd4;
        #10;
        #1;

        check_outputs(16'h00F0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Logical shift left by 8 (byte shift)", test_num);
        D = 16'h00FF;
        shift_ctrl = 4'd8;
        #10;
        #1;

        check_outputs(16'hFF00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Logical shift left by 12", test_num);
        D = 16'h0001;
        shift_ctrl = 4'd12;
        #10;
        #1;

        check_outputs(16'h1000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Shift to most significant bit (shift 15)", test_num);
        D = 16'h0001;
        shift_ctrl = 4'd15;
        #10;
        #1;

        check_outputs(16'h8000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bits shifting out (overflow check)", test_num);
        D = 16'h8000;
        shift_ctrl = 4'd1;
        #10;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All ones input shifted by 8", test_num);
        D = 16'hFFFF;
        shift_ctrl = 4'd8;
        #10;
        #1;

        check_outputs(16'hFF00);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero input check", test_num);
        D = 16'h0000;
        shift_ctrl = 4'd7;
        #10;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Complex pattern shift", test_num);
        D = 16'h5555;
        shift_ctrl = 4'd2;
        #10;
        #1;

        check_outputs(16'h5554);
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
        input [15:0] expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
