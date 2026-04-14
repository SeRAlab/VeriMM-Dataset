`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] digi_in;
    wire [6:0] digi_out1;
    wire [6:0] digi_out2;
    wire [6:0] digi_out3;
    wire [6:0] digi_out4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .digi_in(digi_in),
        .digi_out1(digi_out1),
        .digi_out2(digi_out2),
        .digi_out3(digi_out3),
        .digi_out4(digi_out4)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Activate Display 1 (Select=4'h1)", test_num);
            digi_in = {4'h1, 1'b0, 7'h3F};
            #1;

            check_outputs(7'h3F, 7'h00, 7'h00, 7'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Activate Display 2 (Select=4'h2)", test_num);
            digi_in = {4'h2, 1'b0, 7'h06};
            #1;

            check_outputs(7'h00, 7'h06, 7'h00, 7'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Activate Display 3 (Select=4'h4)", test_num);
            digi_in = {4'h4, 1'b0, 7'h5B};
            #1;

            check_outputs(7'h00, 7'h00, 7'h5B, 7'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Activate Display 4 (Select=4'h8)", test_num);
            digi_in = {4'h8, 1'b0, 7'h4F};
            #1;

            check_outputs(7'h00, 7'h00, 7'h00, 7'h4F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Invalid Selection (Select=4'h0)", test_num);
            digi_in = {4'h0, 1'b0, 7'h7F};
            #1;

            check_outputs(7'h00, 7'h00, 7'h00, 7'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Invalid Selection (Select=4'h3)", test_num);
            digi_in = {4'h3, 1'b0, 7'h66};
            #1;

            check_outputs(7'h00, 7'h00, 7'h00, 7'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Invalid Selection (Select=4'hF)", test_num);
            digi_in = {4'hF, 1'b0, 7'h6D};
            #1;

            check_outputs(7'h00, 7'h00, 7'h00, 7'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Verify bit 7 of input is ignored", test_num);
            digi_in = {4'h1, 1'b1, 7'h7D};
            #1;

            check_outputs(7'h7D, 7'h00, 7'h00, 7'h00);
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
        input [6:0] expected_digi_out1;
        input [6:0] expected_digi_out2;
        input [6:0] expected_digi_out3;
        input [6:0] expected_digi_out4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_digi_out1 === (expected_digi_out1 ^ digi_out1 ^ expected_digi_out1) &&
                expected_digi_out2 === (expected_digi_out2 ^ digi_out2 ^ expected_digi_out2) &&
                expected_digi_out3 === (expected_digi_out3 ^ digi_out3 ^ expected_digi_out3) &&
                expected_digi_out4 === (expected_digi_out4 ^ digi_out4 ^ expected_digi_out4)) begin
                $display("PASS");
                $display("  Outputs: digi_out1=%h, digi_out2=%h, digi_out3=%h, digi_out4=%h",
                         digi_out1, digi_out2, digi_out3, digi_out4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digi_out1=%h, digi_out2=%h, digi_out3=%h, digi_out4=%h",
                         expected_digi_out1, expected_digi_out2, expected_digi_out3, expected_digi_out4);
                $display("  Got:      digi_out1=%h, digi_out2=%h, digi_out3=%h, digi_out4=%h",
                         digi_out1, digi_out2, digi_out3, digi_out4);
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
