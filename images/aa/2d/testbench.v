`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data;
    reg sel;
    wire [8:0] out;
    wire parity;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .sel(sel),
        .out(out),
        .parity(parity)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            data = 8'h00; sel = 0;
            #10;
            $display("Testcase %0d: Generation - All Zeros", test_num);
            #1;

            check_outputs(9'h000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            data = 8'h01; sel = 0;
            #10;
            $display("Testcase %0d: Generation - Single Bit (Odd)", test_num);
            #1;

            check_outputs(9'h003, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            data = 8'h03; sel = 0;
            #10;
            $display("Testcase %0d: Generation - Two Bits (Even)", test_num);
            #1;

            check_outputs(9'h006, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            data = 8'h7F; sel = 0;
            #10;
            $display("Testcase %0d: Generation - Seven Bits (Odd)", test_num);
            #1;

            check_outputs(9'h0FF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            data = 8'hFF; sel = 0;
            #10;
            $display("Testcase %0d: Generation - All Ones (Even)", test_num);
            #1;

            check_outputs(9'h1FE, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            data = 8'h00; sel = 1;
            #10;
            $display("Testcase %0d: Checking - Correct Parity (Zero)", test_num);
            #1;

            check_outputs(9'h000, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            data = 8'h01; sel = 1;
            #10;
            $display("Testcase %0d: Checking - Incorrect Parity (0x01)", test_num);
            #1;

            check_outputs(9'h000, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            data = 8'h03; sel = 1;
            #10;
            $display("Testcase %0d: Checking - Correct Parity (0x03)", test_num);
            #1;

            check_outputs(9'h003, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            data = 8'h02; sel = 1;
            #10;
            $display("Testcase %0d: Checking - Incorrect Parity (0x02)", test_num);
            #1;

            check_outputs(9'h003, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            data = 8'hFF; sel = 1;
            #10;
            $display("Testcase %0d: Checking - Correct Parity (All Ones)", test_num);
            #1;

            check_outputs(9'h0FF, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            data = 8'hFE; sel = 1;
            #10;
            $display("Testcase %0d: Checking - Incorrect Parity (0xFE)", test_num);
            #1;

            check_outputs(9'h0FF, 1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            data = 8'h80; sel = 1;
            #10;
            $display("Testcase %0d: Checking - Incorrect Parity (0x80)", test_num);
            #1;

            check_outputs(9'h081, 1'b1);
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
        testcase011();
        testcase012();
        
        
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
        input [8:0] expected_out;
        input expected_parity;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_parity === (expected_parity ^ parity ^ expected_parity)) begin
                $display("PASS");
                $display("  Outputs: out=%h, parity=%b",
                         out, parity);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, parity=%b",
                         expected_out, expected_parity);
                $display("  Got:      out=%h, parity=%b",
                         out, parity);
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
