`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] i0;
    reg [6:0] i1;
    wire [6:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i0(i0),
        .i1(i1),
        .s(s)
    );
    task testcase001;

    begin
        test_num = 1;
        i0 = 7'd0; i1 = 7'd0;
        #1;

        check_outputs(7'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        i0 = 7'd10; i1 = 7'd5;
        #1;

        check_outputs(7'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        i0 = 7'd100; i1 = 7'd27;
        #1;

        check_outputs(7'd127);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        i0 = 7'd127; i1 = 7'd1;
        #1;

        check_outputs(7'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        i0 = 7'b1111110; i1 = 7'b0000001;
        #1;

        check_outputs(7'b1111111);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        i0 = 7'b0101010; i1 = 7'b0010101;
        #1;

        check_outputs(7'b0111111);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        i0 = 7'd127; i1 = 7'd127;
        #1;

        check_outputs(7'd126);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        i0 = 7'd64; i1 = 7'd64;
        #1;

        check_outputs(7'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        i0 = 7'h55; i1 = 7'h2A;
        #1;

        check_outputs(7'h7F);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        i0 = 7'd42; i1 = 7'd42;
        #1;

        check_outputs(7'd84);
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
        input [6:0] expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: s=%h",
                         s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s=%h",
                         expected_s);
                $display("  Got:      s=%h",
                         s);
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
