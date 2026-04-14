`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire C;
    wire [7:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .S(S)
    );
    task testcase001;

        begin
            A = 8'h00; B = 8'h00;
            $display("Testcase 001: A=%h, B=%h", A, B);
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            A = 8'h12; B = 8'h34;
            $display("Testcase 002: A=%h, B=%h", A, B);
            #1;

            check_outputs(1'b0, 8'h46);
        end
        endtask

    task testcase003;

        begin
            A = 8'hAA; B = 8'h55;
            $display("Testcase 003: A=%h, B=%h", A, B);
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            A = 8'h80; B = 8'h80;
            $display("Testcase 004: A=%h, B=%h", A, B);
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            A = 8'hFF; B = 8'h01;
            $display("Testcase 005: A=%h, B=%h", A, B);
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase006;

        begin
            A = 8'hFF; B = 8'hFF;
            $display("Testcase 006: A=%h, B=%h", A, B);
            #1;

            check_outputs(1'b1, 8'hFE);
        end
        endtask

    task testcase007;

        begin
            A = 8'hFF; B = 8'h01;
            $display("Testcase 007: A=%h, B=%h", A, B);
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase008;

        begin
            A = 8'h0F; B = 8'h01;
            $display("Testcase 008: A=%h, B=%h", A, B);
            #1;

            check_outputs(1'b0, 8'h10);
        end
        endtask

    task testcase009;

        begin
            A = 8'h47; B = 8'hB2;
            $display("Testcase 009: A=%h, B=%h", A, B);
            #1;

            check_outputs(1'b0, 8'hF9);
        end
        endtask

    task testcase010;

        begin
            A = 8'hE5; B = 8'h3D;
            $display("Testcase 010: A=%h, B=%h", A, B);
            #1;

            check_outputs(1'b1, 8'h22);
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
        input expected_C;
        input [7:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: C=%b, S=%h",
                         C, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%b, S=%h",
                         expected_C, expected_S);
                $display("  Got:      C=%b, S=%h",
                         C, S);
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
