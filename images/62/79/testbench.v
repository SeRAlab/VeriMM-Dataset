`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg CIN;
    reg SUB;
    wire OVF;
    wire [7:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CIN(CIN),
        .SUB(SUB),
        .OVF(OVF),
        .SUM(SUM)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive Addition (No Overflow)", test_num);
            A = 8'd10;
            B = 8'd20;
            CIN = 1'b0;
            SUB = 1'b0;
            #1;

            check_outputs(1'b0, 8'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive Addition (With Overflow)", test_num);
            A = 8'd120;
            B = 8'd10;
            CIN = 1'b0;
            SUB = 1'b0;

            #1;


            check_outputs(1'b1, 8'h82);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative Addition (No Overflow)", test_num);
            A = 8'hF6;
            B = 8'hEC;
            CIN = 1'b0;
            SUB = 1'b0;

            #1;


            check_outputs(1'b0, 8'hE2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative Addition (With Overflow)", test_num);
            A = 8'h81;
            B = 8'h81;
            CIN = 1'b0;
            SUB = 1'b0;

            #1;


            check_outputs(1'b1, 8'h02);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction Positive Result (No Overflow)", test_num);
            A = 8'd25;
            B = 8'd10;
            CIN = 1'b0;
            SUB = 1'b1;

            #1;


            check_outputs(1'b0, 8'h0F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction Negative Result (No Overflow)", test_num);
            A = 8'd10;
            B = 8'd25;
            CIN = 1'b0;
            SUB = 1'b1;

            #1;


            check_outputs(1'b0, 8'hF1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (With Overflow - Positive Result)", test_num);
            A = 8'd100;
            B = 8'hCE;
            CIN = 1'b0;
            SUB = 1'b1;

            #1;


            check_outputs(1'b1, 8'h96);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (With Overflow - Negative Result)", test_num);
            A = 8'h9C;
            B = 8'd50;
            CIN = 1'b0;
            SUB = 1'b1;

            #1;


            check_outputs(1'b1, 8'h6A);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition with CIN", test_num);
            A = 8'd10;
            B = 8'd10;
            CIN = 1'b1;
            SUB = 1'b0;

            #1;


            check_outputs(1'b0, 8'h15);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction with CIN", test_num);
            A = 8'd10;
            B = 8'd5;
            CIN = 1'b1;
            SUB = 1'b1;

            #1;


            check_outputs(1'b0, 8'h06);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition Edge Case (Zero)", test_num);
            A = 8'hFF;
            B = 8'h01;
            CIN = 1'b0;
            SUB = 1'b0;

            #1;


            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction Edge Case (Max Negative)", test_num);
            A = 8'h80;
            B = 8'h01;
            CIN = 1'b0;
            SUB = 1'b1;

            #1;


            check_outputs(1'b1, 8'h7F);
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
        input expected_OVF;
        input [7:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OVF === (expected_OVF ^ OVF ^ expected_OVF) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: OVF=%b, SUM=%h",
                         OVF, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OVF=%b, SUM=%h",
                         expected_OVF, expected_SUM);
                $display("  Got:      OVF=%b, SUM=%h",
                         OVF, SUM);
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
