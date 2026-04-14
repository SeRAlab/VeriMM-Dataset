`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] EXT;
    reg [31:0] Qb_FORWARD;
    reg S;
    wire [31:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EXT(EXT),
        .Qb_FORWARD(Qb_FORWARD),
        .S(S),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Select EXT (S=0) with basic values", test_num);
            EXT = 32'hCAFE_BABE;
            Qb_FORWARD = 32'hDEAD_BEEF;
            S = 1'b0;
            #1;

            check_outputs(32'hCAFE_BABE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Select Qb_FORWARD (S=1) with basic values", test_num);
            EXT = 32'hCAFE_BABE;
            Qb_FORWARD = 32'hDEAD_BEEF;
            S = 1'b1;
            #1;

            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Select EXT (S=0) with all bits high", test_num);
            EXT = 32'hFFFF_FFFF;
            Qb_FORWARD = 32'h0000_0000;
            S = 1'b0;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Select Qb_FORWARD (S=1) with all bits low", test_num);
            EXT = 32'hFFFF_FFFF;
            Qb_FORWARD = 32'h0000_0000;
            S = 1'b1;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Select EXT (S=0) with alternating bit pattern", test_num);
            EXT = 32'hAAAA_AAAA;
            Qb_FORWARD = 32'h5555_5555;
            S = 1'b0;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Select Qb_FORWARD (S=1) with alternating bit pattern", test_num);
            EXT = 32'hAAAA_AAAA;
            Qb_FORWARD = 32'h5555_5555;
            S = 1'b1;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Change select signal with constant inputs", test_num);
            EXT = 32'h1234_5678;
            Qb_FORWARD = 32'h8765_4321;
            S = 1'b0;
            #5;
            S = 1'b1;
            #1;

            check_outputs(32'h8765_4321);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Change input signal while selected", test_num);
            S = 1'b0;
            EXT = 32'h0000_1111;
            Qb_FORWARD = 32'hFFFF_EEEE;
            #5;
            EXT = 32'h2222_3333;
            #1;

            check_outputs(32'h2222_3333);
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
        input [31:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
