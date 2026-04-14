`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .P(P)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 8'd0;
            B = 8'd0;
            $display("Test %0d: Zero multiplication (0 * 0)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 8'd12;
            B = 8'd5;
            $display("Test %0d: Small positive unsigned (12 * 5)", test_num);
            #1;

            check_outputs(8'd60);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 8'hFF;
            B = 8'd1;
            $display("Test %0d: Identity/Sign extension check (0xFF * 1)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 8'hFF;
            B = 8'hFF;
            $display("Test %0d: Signed negative multiplication (-1 * -1)", test_num);
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 8'd10;
            B = 8'sb11110110;
            $display("Test %0d: Positive times Negative (10 * -10)", test_num);
            #1;

            check_outputs(8'h9C);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 8'h80;
            B = 8'd2;
            $display("Test %0d: Signed Overflow/Unsigned boundary (0x80 * 2)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 8'd15;
            B = 8'd15;
            $display("Test %0d: Squaring (15 * 15)", test_num);
            #1;

            check_outputs(8'd225);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 8'h81;
            B = 8'hFE;
            $display("Test %0d: Large negative multiplication (-127 * -2)", test_num);
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 8'd127;
            B = 8'd2;
            $display("Test %0d: Maximum positive signed boundary (127 * 2)", test_num);
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 8'h55;
            B = 8'hAA;
            $display("Test %0d: Alternating bit patterns (0x55 * 0xAA)", test_num);

            #1;


            check_outputs(8'h72);
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
        input [7:0] expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
