`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [4:0] shamt;
    reg [1:0] stype;
    wire [31:0] r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .shamt(shamt),
        .stype(stype),
        .r(r)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Logical Right Shift (shamt=4)", test_num);
            a = 32'hF000_0000;
            shamt = 5'd4;
            stype = 2'b00;
            #1;

            check_outputs(32'h0F00_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Logical Right Shift (shamt=31)", test_num);
            a = 32'hFFFF_FFFF;
            shamt = 5'd31;
            stype = 2'b00;
            #1;

            check_outputs(32'h0000_0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Logical Left Shift (shamt=8)", test_num);
            a = 32'h0000_00FF;
            shamt = 5'd8;
            stype = 2'b01;
            #1;

            check_outputs(32'h0000_FF00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Logical Left Shift (shamt=31)", test_num);
            a = 32'h0000_0001;
            shamt = 5'd31;
            stype = 2'b01;
            #1;

            check_outputs(32'h8000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Arithmetic Right Shift (Positive, shamt=4)", test_num);
            a = 32'h4000_0000;
            shamt = 5'd4;
            stype = 2'b10;
            #1;

            check_outputs(32'h0400_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Arithmetic Right Shift (Negative, shamt=4)", test_num);
            a = 32'h8000_0000;
            shamt = 5'd4;
            stype = 2'b10;
            #1;

            check_outputs(32'hF800_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Arithmetic Right Shift (Negative, shamt=31)", test_num);
            a = 32'h8000_0000;
            shamt = 5'd31;
            stype = 2'b10;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Default Case (stype=11, should return 'a')", test_num);
            a = 32'h1234_5678;
            shamt = 5'd15;
            stype = 2'b11;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Shift (LRS)", test_num);
            a = 32'hDEAD_BEEF;
            shamt = 5'd0;
            stype = 2'b00;
            #1;

            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Arithmetic Right Shift (All 1s)", test_num);
            a = 32'hFFFF_FFFF;
            shamt = 5'd16;
            stype = 2'b10;
            #1;

            check_outputs(32'hFFFF_FFFF);
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
        input [31:0] expected_r;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_r === (expected_r ^ r ^ expected_r)) begin
                $display("PASS");
                $display("  Outputs: r=%h",
                         r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r=%h",
                         expected_r);
                $display("  Got:      r=%h",
                         r);
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
