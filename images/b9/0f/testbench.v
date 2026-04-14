`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [2:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All inputs low", test_num);
            in = 8'b0000_0000;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: LSB only (Bit 0)", test_num);
            in = 8'b0000_0001;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Bit 1 active", test_num);
            in = 8'b0000_0010;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Bit 2 active", test_num);
            in = 8'b0000_0100;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: MSB active (Bit 7)", test_num);
            in = 8'b1000_0000;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Multiple bits (0 and 1), check priority index 1", test_num);
            in = 8'b0000_0011;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Multiple bits (0 and 7), check priority index 7", test_num);
            in = 8'b1000_0001;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Mid-range bits (3, 4, 5), check priority index 5", test_num);
            in = 8'b0011_1000;
            #1;

            check_outputs(3'd5);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: All bits active, check priority index 7", test_num);
            in = 8'b1111_1111;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Sparse bits (1, 3, 6), check priority index 6", test_num);
            in = 8'b0100_1010;
            #1;

            check_outputs(3'd6);
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
        input [2:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
