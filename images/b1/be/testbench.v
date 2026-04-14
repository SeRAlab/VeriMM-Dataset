`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] DIN;
    reg INIT;
    reg [2:0] IPOS;
    wire [2:0] OPOS;
    wire VALID;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DIN(DIN),
        .INIT(INIT),
        .IPOS(IPOS),
        .OPOS(OPOS),
        .VALID(VALID)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: INIT=1, DIN with low bits set", test_num);
            DIN = 8'h05;
            INIT = 1;
            IPOS = 3'd0;

            #1;


            check_outputs(3'd5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: INIT=1, DIN with only high bits set", test_num);
            DIN = 8'h80;
            INIT = 1;
            IPOS = 3'd2;

            #1;


            check_outputs(3'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: INIT=1, DIN is zero", test_num);
            DIN = 8'h00;
            INIT = 1;
            IPOS = 3'd0;

            #1;


            check_outputs(3'd0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: INIT=0, IPOS=0 (No Shift)", test_num);
            DIN = 8'h07;
            INIT = 0;
            IPOS = 3'd0;

            #1;


            check_outputs(3'd7, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: INIT=0, IPOS=1 (Shift Left by 1)", test_num);
            DIN = 8'h01;
            INIT = 0;
            IPOS = 3'd1;

            #1;


            check_outputs(3'd2, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: INIT=0, IPOS=3 (Shift Left by 3)", test_num);
            DIN = 8'h01;
            INIT = 0;
            IPOS = 3'd3;

            #1;


            check_outputs(3'd0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: INIT=0, IPOS=6 (Shift Left to MSB of 7-bit reg)", test_num);
            DIN = 8'h01;
            INIT = 0;
            IPOS = 3'd6;

            #1;


            check_outputs(3'd0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: INIT=0, IPOS=1, MSB of 7-bit reg shifts out", test_num);
            DIN = 8'h40;
            INIT = 0;
            IPOS = 3'd1;

            #1;


            check_outputs(3'd0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: INIT=0, IPOS=7 (Full Shift out of 7-bit reg)", test_num);
            DIN = 8'h01;
            INIT = 0;
            IPOS = 3'd7;

            #1;


            check_outputs(3'd0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: INIT=0, DIN zero", test_num);
            DIN = 8'h00;
            INIT = 0;
            IPOS = 3'd2;

            #1;


            check_outputs(3'd0, 1'b0);
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
        input [2:0] expected_OPOS;
        input expected_VALID;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OPOS === (expected_OPOS ^ OPOS ^ expected_OPOS) &&
                expected_VALID === (expected_VALID ^ VALID ^ expected_VALID)) begin
                $display("PASS");
                $display("  Outputs: OPOS=%h, VALID=%b",
                         OPOS, VALID);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OPOS=%h, VALID=%b",
                         expected_OPOS, expected_VALID);
                $display("  Got:      OPOS=%h, VALID=%b",
                         OPOS, VALID);
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
