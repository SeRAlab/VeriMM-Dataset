`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] DIN;
    reg [1:0] SHIFT;
    wire [3:0] DOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DIN(DIN),
        .SHIFT(SHIFT),
        .DOUT(DOUT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Shift 00 (No shift) - DIN=1010", test_num);
            DIN = 4'b1010;
            SHIFT = 2'b00;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Shift 01 (Right rotate 1) - DIN=1010", test_num);
            DIN = 4'b1010;
            SHIFT = 2'b01;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Shift 10 (Right rotate 2) - DIN=1010", test_num);
            DIN = 4'b1010;
            SHIFT = 2'b10;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Shift 11 (Right rotate 3) - DIN=1010", test_num);
            DIN = 4'b1010;
            SHIFT = 2'b11;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Shift 01 (Right rotate 1) - DIN=1100", test_num);
            DIN = 4'b1100;
            SHIFT = 2'b01;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Shift 10 (Right rotate 2) - DIN=1100", test_num);
            DIN = 4'b1100;
            SHIFT = 2'b10;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Shift 11 (Right rotate 3) - DIN=1100", test_num);
            DIN = 4'b1100;
            SHIFT = 2'b11;
            #1;

            check_outputs(4'b1001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Shift 01 (Right rotate 1) - DIN=0001", test_num);
            DIN = 4'b0001;
            SHIFT = 2'b01;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Shift 10 (Right rotate 2) - DIN=1111", test_num);
            DIN = 4'b1111;
            SHIFT = 2'b10;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Shift 11 (Right rotate 3) - DIN=0000", test_num);
            DIN = 4'b0000;
            SHIFT = 2'b11;
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
        input [3:0] expected_DOUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DOUT === (expected_DOUT ^ DOUT ^ expected_DOUT)) begin
                $display("PASS");
                $display("  Outputs: DOUT=%h",
                         DOUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOUT=%h",
                         expected_DOUT);
                $display("  Got:      DOUT=%h",
                         DOUT);
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
