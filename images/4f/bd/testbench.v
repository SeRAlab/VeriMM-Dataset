`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg EN;
    wire [3:0] C;
    wire OV;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .EN(EN),
        .C(C),
        .OV(OV)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=0, inputs should result in 0 outputs", test_num);
            A = 4'd5;
            B = 4'd10;
            EN = 1'b0;
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, No Overflow (Sum < 15)", test_num);
            A = 4'd3;
            B = 4'd4;
            EN = 1'b1;
            #1;

            check_outputs(4'd7, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, Edge Case No Overflow (Sum = 15)", test_num);
            A = 4'd7;
            B = 4'd8;
            EN = 1'b1;
            #1;

            check_outputs(4'd15, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, Edge Case Overflow (Sum = 16)", test_num);
            A = 4'd8;
            B = 4'd8;
            EN = 1'b1;
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, Large Sum Overflow", test_num);
            A = 4'd12;
            B = 4'd10;
            EN = 1'b1;

            #1;


            check_outputs(4'd6, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, Maximum Sum Overflow", test_num);
            A = 4'd15;
            B = 4'd15;
            EN = 1'b1;

            #1;


            check_outputs(4'd14, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, Zero Inputs", test_num);
            A = 4'd0;
            B = 4'd0;
            EN = 1'b1;
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition EN from 1 to 0 with overflow inputs", test_num);

            A = 4'd15;
            B = 4'd2;
            EN = 1'b1;
            #2;

            EN = 1'b0;
            #1;

            check_outputs(4'd0, 1'b0);
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
        input [3:0] expected_C;
        input expected_OV;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_OV === (expected_OV ^ OV ^ expected_OV)) begin
                $display("PASS");
                $display("  Outputs: C=%h, OV=%b",
                         C, OV);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h, OV=%b",
                         expected_C, expected_OV);
                $display("  Got:      C=%h, OV=%b",
                         C, OV);
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
