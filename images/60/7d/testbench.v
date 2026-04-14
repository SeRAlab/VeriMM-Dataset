`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg en_in_n;
    reg [7:0] v;
    wire en_out;
    wire gs;
    wire [2:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .en_in_n(en_in_n),
        .v(v),
        .en_out(en_out),
        .gs(gs),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            v = 8'b1111_1111;
            en_in_n = 1'b1;

            #1;


            check_outputs(1'b1, 1'b1, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            v = 8'b0000_0000;
            en_in_n = 1'b0;

            #1;


            check_outputs(1'b0, 1'b1, 3'b000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            v = 8'b0000_0001;
            en_in_n = 1'b0;

            #1;


            check_outputs(1'b1, 1'b0, 3'b000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            v = 8'b0000_0010;
            en_in_n = 1'b0;

            #1;


            check_outputs(1'b1, 1'b0, 3'b001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            v = 8'b0000_1000;
            en_in_n = 1'b0;

            #1;


            check_outputs(1'b1, 1'b0, 3'b011);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            v = 8'b1000_0000;
            en_in_n = 1'b0;

            #1;


            check_outputs(1'b1, 1'b0, 3'b111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            v = 8'b1000_0011;
            en_in_n = 1'b0;

            #1;


            check_outputs(1'b1, 1'b0, 3'b111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            v = 8'b0001_0100;
            en_in_n = 1'b0;

            #1;


            check_outputs(1'b1, 1'b0, 3'b100);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            v = 8'b1111_1111;
            en_in_n = 1'b0;

            #1;


            check_outputs(1'b1, 1'b0, 3'b111);
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
        input expected_en_out;
        input expected_gs;
        input [2:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_en_out === (expected_en_out ^ en_out ^ expected_en_out) &&
                expected_gs === (expected_gs ^ gs ^ expected_gs) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: en_out=%b, gs=%b, y=%h",
                         en_out, gs, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: en_out=%b, gs=%b, y=%h",
                         expected_en_out, expected_gs, expected_y);
                $display("  Got:      en_out=%b, gs=%b, y=%h",
                         en_out, gs, y);
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
