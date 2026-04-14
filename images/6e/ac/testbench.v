`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] A;
    reg [23:0] B;
    reg [23:0] C;
    reg [23:0] D;
    reg [23:0] E;
    reg [23:0] F;
    reg [23:0] G;
    reg [23:0] H;
    reg [2:0] sel;
    wire [23:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .E(E),
        .F(F),
        .G(G),
        .H(H),
        .sel(sel),
        .OUT(OUT)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 24'hA1A1A1; B = 24'hB2B2B2; C = 24'hC3C3C3; D = 24'hD4D4D4;
            E = 24'hE5E5E5; F = 24'hF6F6F6; G = 24'h070707; H = 24'h080808;
            sel = 3'b000;
            $display("Test %0d: Select A", test_num);
            #1;

            check_outputs(24'hA1A1A1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 24'hA1A1A1; B = 24'hB2B2B2; C = 24'hC3C3C3; D = 24'hD4D4D4;
            E = 24'hE5E5E5; F = 24'hF6F6F6; G = 24'h070707; H = 24'h080808;
            sel = 3'b001;
            $display("Test %0d: Select B", test_num);
            #1;

            check_outputs(24'hB2B2B2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 24'hA1A1A1; B = 24'hB2B2B2; C = 24'hC3C3C3; D = 24'hD4D4D4;
            E = 24'hE5E5E5; F = 24'hF6F6F6; G = 24'h070707; H = 24'h080808;
            sel = 3'b010;
            $display("Test %0d: Select C", test_num);
            #1;

            check_outputs(24'hC3C3C3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 24'hA1A1A1; B = 24'hB2B2B2; C = 24'hC3C3C3; D = 24'hD4D4D4;
            E = 24'hE5E5E5; F = 24'hF6F6F6; G = 24'h070707; H = 24'h080808;
            sel = 3'b011;
            $display("Test %0d: Select D", test_num);
            #1;

            check_outputs(24'hD4D4D4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 24'hA1A1A1; B = 24'hB2B2B2; C = 24'hC3C3C3; D = 24'hD4D4D4;
            E = 24'hE5E5E5; F = 24'hF6F6F6; G = 24'h070707; H = 24'h080808;
            sel = 3'b100;
            $display("Test %0d: Select E", test_num);
            #1;

            check_outputs(24'hE5E5E5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 24'hA1A1A1; B = 24'hB2B2B2; C = 24'hC3C3C3; D = 24'hD4D4D4;
            E = 24'hE5E5E5; F = 24'hF6F6F6; G = 24'h070707; H = 24'h080808;
            sel = 3'b101;
            $display("Test %0d: Select F", test_num);
            #1;

            check_outputs(24'hF6F6F6);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 24'hA1A1A1; B = 24'hB2B2B2; C = 24'hC3C3C3; D = 24'hD4D4D4;
            E = 24'hE5E5E5; F = 24'hF6F6F6; G = 24'h070707; H = 24'h080808;
            sel = 3'b110;
            $display("Test %0d: Select G", test_num);
            #1;

            check_outputs(24'h070707);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 24'hA1A1A1; B = 24'hB2B2B2; C = 24'hC3C3C3; D = 24'hD4D4D4;
            E = 24'hE5E5E5; F = 24'hF6F6F6; G = 24'h070707; H = 24'h080808;
            sel = 3'b111;
            $display("Test %0d: Select H", test_num);
            #1;

            check_outputs(24'h080808);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 24'hFFFFFF; B = 24'hFFFFFF; C = 24'hFFFFFF; D = 24'hFFFFFF;
            E = 24'hFFFFFF; F = 24'hFFFFFF; G = 24'hFFFFFF; H = 24'hFFFFFF;
            sel = 3'b101;
            $display("Test %0d: Identical Inputs", test_num);
            #1;

            check_outputs(24'hFFFFFF);
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
        input [23:0] expected_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h",
                         expected_OUT);
                $display("  Got:      OUT=%h",
                         OUT);
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
