`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] COUNT;
    reg LATCHCNT;
    wire [7:0] LATCHLSB;
    wire [7:0] LATCHMSB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .COUNT(COUNT),
        .LATCHCNT(LATCHCNT),
        .LATCHLSB(LATCHLSB),
        .LATCHMSB(LATCHMSB)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Input zero, LATCHCNT low", test_num);
        COUNT = 16'h0000;
        LATCHCNT = 1'b0;
        #1;

        check_outputs(8'h00, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Input all ones, LATCHCNT high", test_num);
        COUNT = 16'hFFFF;
        LATCHCNT = 1'b1;
        #1;

        check_outputs(8'hFF, 8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Input 0x1234, verify MSB/LSB separation", test_num);
        COUNT = 16'h1234;
        LATCHCNT = 1'b0;
        #1;

        check_outputs(8'h34, 8'h12);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Input 0xABCD, verify MSB/LSB separation", test_num);
        COUNT = 16'hABCD;
        LATCHCNT = 1'b1;
        #1;

        check_outputs(8'hCD, 8'hAB);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Verify LATCHCNT transparency (LATCHCNT=0)", test_num);

        COUNT = 16'h55AA;
        LATCHCNT = 1'b0;
        #1;

        check_outputs(8'hAA, 8'h55);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Verify LATCHCNT transparency (LATCHCNT=1)", test_num);
        COUNT = 16'hA55A;
        LATCHCNT = 1'b1;
        #1;

        check_outputs(8'h5A, 8'hA5);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Changing COUNT while LATCHCNT is stable", test_num);
        LATCHCNT = 1'b0;
        COUNT = 16'h1122;
        #5;
        COUNT = 16'h3344;
        #1;

        check_outputs(8'h44, 8'h33);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Boundary value 0x00FF", test_num);
        COUNT = 16'h00FF;
        LATCHCNT = 1'b1;
        #1;

        check_outputs(8'hFF, 8'h00);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Boundary value 0xFF00", test_num);
        COUNT = 16'hFF00;
        LATCHCNT = 1'b0;
        #1;

        check_outputs(8'h00, 8'hFF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Toggle LATCHCNT while COUNT is constant", test_num);
        COUNT = 16'hBEEF;
        LATCHCNT = 1'b0;
        #2;
        LATCHCNT = 1'b1;
        #2;
        LATCHCNT = 1'b0;
        #1;

        check_outputs(8'hEF, 8'hBE);
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
        input [7:0] expected_LATCHLSB;
        input [7:0] expected_LATCHMSB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_LATCHLSB === (expected_LATCHLSB ^ LATCHLSB ^ expected_LATCHLSB) &&
                expected_LATCHMSB === (expected_LATCHMSB ^ LATCHMSB ^ expected_LATCHMSB)) begin
                $display("PASS");
                $display("  Outputs: LATCHLSB=%h, LATCHMSB=%h",
                         LATCHLSB, LATCHMSB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LATCHLSB=%h, LATCHMSB=%h",
                         expected_LATCHLSB, expected_LATCHMSB);
                $display("  Got:      LATCHLSB=%h, LATCHMSB=%h",
                         LATCHLSB, LATCHMSB);
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
