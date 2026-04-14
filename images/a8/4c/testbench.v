`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg RST;
    wire OV;
    wire [7:0] S;
    wire UV;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .RST(RST),
        .OV(OV),
        .S(S),
        .UV(UV)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Functionality", test_num);
            A = 8'd15;
            B = 8'd25;
            RST = 1'b1;
            #10;
            #1;

            check_outputs(1'b0, 8'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Positive Addition", test_num);
            RST = 1'b0;
            A = 8'd20;
            B = 8'd30;
            #10;
            #1;

            check_outputs(1'b0, 8'd50, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Negative Addition", test_num);
            RST = 1'b0;
            A = -8'd20;
            B = -8'd30;
            #10;
            #1;

            check_outputs(1'b0, -8'd50, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive Overflow", test_num);
            RST = 1'b0;
            A = 8'd80;
            B = 8'd60;
            #10;
            #1;

            check_outputs(1'b1, 8'sb10001100, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative Overflow", test_num);
            RST = 1'b0;
            A = -8'd80;
            B = -8'd60;
            #10;
            #1;

            check_outputs(1'b1, 8'sb01110100, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed Signs (Pos > |Neg|)", test_num);
            RST = 1'b0;
            A = 8'd50;
            B = -8'd20;
            #10;
            #1;

            check_outputs(1'b0, 8'd30, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed Signs (|Neg| > Pos)", test_num);
            RST = 1'b0;
            A = 8'd20;
            B = -8'd50;
            #10;
            #1;

            check_outputs(1'b0, -8'd30, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Edge Case Max Positive + 1", test_num);
            RST = 1'b0;
            A = 8'd127;
            B = 8'd1;
            #10;
            #1;

            check_outputs(1'b1, -8'd128, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Edge Case Min Negative - 1", test_num);
            RST = 1'b0;
            A = -8'd128;
            B = -8'd1;
            #10;
            #1;

            check_outputs(1'b1, 8'd127, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset After Operation", test_num);
            RST = 1'b1;
            A = 8'd127;
            B = 8'd127;
            #10;
            #1;

            check_outputs(1'b0, 8'd0, 1'b0);
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
        input expected_OV;
        input [7:0] expected_S;
        input expected_UV;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OV === (expected_OV ^ OV ^ expected_OV) &&
                expected_S === (expected_S ^ S ^ expected_S) &&
                expected_UV === (expected_UV ^ UV ^ expected_UV)) begin
                $display("PASS");
                $display("  Outputs: OV=%b, S=%h, UV=%b",
                         OV, S, UV);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OV=%b, S=%h, UV=%b",
                         expected_OV, expected_S, expected_UV);
                $display("  Got:      OV=%b, S=%h, UV=%b",
                         OV, S, UV);
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
