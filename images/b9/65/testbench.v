`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] li;
    wire [2:0] addr_lo;
    wire v_lo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .li(li),
        .addr_lo(addr_lo),
        .v_lo(v_lo)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: No bits active (Input: 8'b00000000)", test_num);
            li = 8'b00000000;

            #1;


            check_outputs(3'b000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Bit 0 active (Input: 8'b00000001)", test_num);
            li = 8'b00000001;
            #1;

            check_outputs(3'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Bit 7 active (Input: 8'b10000000)", test_num);
            li = 8'b10000000;
            #1;

            check_outputs(3'd7, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Bit 3 active (Input: 8'b00001000)", test_num);
            li = 8'b00001000;
            #1;

            check_outputs(3'd3, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Multiple bits active (Input: 8'b00000011)", test_num);
            li = 8'b00000011;
            #1;

            check_outputs(3'd1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Multiple bits active (Input: 8'b10010000)", test_num);
            li = 8'b10010000;
            #1;

            check_outputs(3'd7, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Multiple bits active (Input: 8'b00100110)", test_num);
            li = 8'b00100110;
            #1;

            check_outputs(3'd5, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: All bits active (Input: 8'b11111111)", test_num);
            li = 8'b11111111;
            #1;

            check_outputs(3'd7, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Scattered bits active (Input: 8'b01010101)", test_num);
            li = 8'b01010101;
            #1;

            check_outputs(3'd6, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Bit 4 active (Input: 8'b00010000)", test_num);
            li = 8'b00010000;
            #1;

            check_outputs(3'd4, 1'b1);
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
        input [2:0] expected_addr_lo;
        input expected_v_lo;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_addr_lo === (expected_addr_lo ^ addr_lo ^ expected_addr_lo) &&
                expected_v_lo === (expected_v_lo ^ v_lo ^ expected_v_lo)) begin
                $display("PASS");
                $display("  Outputs: addr_lo=%h, v_lo=%b",
                         addr_lo, v_lo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr_lo=%h, v_lo=%b",
                         expected_addr_lo, expected_v_lo);
                $display("  Got:      addr_lo=%h, v_lo=%b",
                         addr_lo, v_lo);
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
