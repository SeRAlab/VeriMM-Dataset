`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [1:0] sel;
    wire [31:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .sel(sel),
        .Z(Z)
    );
    task testcase001;

        begin
            $display("Test 1: Addition (10 + 20)");
            A = 32'd10;
            B = 32'd20;
            sel = 2'b00;
            #1;

            check_outputs(32'd30);
        end
        endtask

    task testcase002;

        begin
            $display("Test 2: Addition (Overflow case)");
            A = 32'hFFFFFFFF;
            B = 32'h00000001;
            sel = 2'b00;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            $display("Test 3: Subtraction (50 - 20)");
            A = 32'd50;
            B = 32'd20;
            sel = 2'b01;
            #1;

            check_outputs(32'd30);
        end
        endtask

    task testcase004;

        begin
            $display("Test 4: Subtraction (Underflow case)");
            A = 32'd10;
            B = 32'd20;
            sel = 2'b01;
            #1;

            check_outputs(32'hFFFFFFF6);
        end
        endtask

    task testcase005;

        begin
            $display("Test 5: Multiplication (12 * 11)");
            A = 32'd12;
            B = 32'd11;
            sel = 2'b10;
            #1;

            check_outputs(32'd132);
        end
        endtask

    task testcase006;

        begin
            $display("Test 6: Multiplication (Large Result Truncation)");
            A = 32'h00010000;
            B = 32'h00010000;
            sel = 2'b10;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            $display("Test 7: Division (100 / 4)");
            A = 32'd100;
            B = 32'd4;
            sel = 2'b11;
            #1;

            check_outputs(32'd25);
        end
        endtask

    task testcase008;

        begin
            $display("Test 8: Integer Division (7 / 3)");
            A = 32'd7;
            B = 32'd3;
            sel = 2'b11;
            #1;

            check_outputs(32'd2);
        end
        endtask

    task testcase009;

        begin
            $display("Test 9: Division by Zero Safeguard");
            A = 32'd100;
            B = 32'd0;
            sel = 2'b11;


            #1;



            check_outputs(32'd0);
        end
        endtask

    task testcase010;

        begin
            $display("Test 10: Zero Inputs (All operations)");
            A = 32'd0;
            B = 32'd0;
            sel = 2'b00; #1;
 check_outputs(32'd0);
            sel = 2'b01; #1;
 check_outputs(32'd0);
            sel = 2'b10; #1;
 check_outputs(32'd0);
            sel = 2'b11; #1;
 check_outputs(32'd0);
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
        input [31:0] expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%h",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%h",
                         expected_Z);
                $display("  Got:      Z=%h",
                         Z);
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
