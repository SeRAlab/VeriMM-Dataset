`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] b11;
    reg [15:0] b12;
    reg [15:0] b21;
    reg [15:0] b22;
    reg [15:0] c111;
    reg [15:0] c112;
    reg [15:0] c121;
    reg [15:0] c122;
    reg [15:0] c211;
    reg [15:0] c212;
    reg [15:0] c221;
    reg [15:0] c222;
    reg [15:0] inputA;
    reg [15:0] inputB;
    wire [15:0] out1;
    wire [15:0] out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b11(b11),
        .b12(b12),
        .b21(b21),
        .b22(b22),
        .c111(c111),
        .c112(c112),
        .c121(c121),
        .c122(c122),
        .c211(c211),
        .c212(c212),
        .c221(c221),
        .c222(c222),
        .inputA(inputA),
        .inputB(inputB),
        .out1(out1),
        .out2(out2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs, weights, and biases zero", test_num);
            inputA = 16'h0000;
            inputB = 16'h0000;
            c111 = 16'h0000; c112 = 16'h0000; c121 = 16'h0000; c122 = 16'h0000;
            c211 = 16'h0000; c212 = 16'h0000; c221 = 16'h0000; c222 = 16'h0000;
            b11  = 16'h0000; b12  = 16'h0000; b21  = 16'h0000; b22  = 16'h0000;


            #1;



            check_outputs(16'h8000, 16'h8000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum positive bias (Saturating Sigmoid High)", test_num);
            inputA = 16'h0001;
            inputB = 16'h0001;
            c111 = 16'h0001; c112 = 16'h0001; c121 = 16'h0001; c122 = 16'h0001;
            c211 = 16'h0001; c212 = 16'h0001; c221 = 16'h0001; c222 = 16'h0001;


            b11  = 16'h7FFF; b12  = 16'h7FFF; b21  = 16'h7FFF; b22  = 16'h7FFF;
            #1;

            check_outputs(16'hFFFF, 16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum negative bias (Saturating Sigmoid Low)", test_num);
            inputA = 16'h0001;
            inputB = 16'h0001;
            c111 = 16'h0001; c112 = 16'h0001; c121 = 16'h0001; c122 = 16'h0001;
            c211 = 16'h0001; c212 = 16'h0001; c221 = 16'h0001; c222 = 16'h0001;


            b11  = 16'h8000; b12  = 16'h8000; b21  = 16'h8000; b22  = 16'h8000;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating weight influence", test_num);
            inputA = 16'h4000;
            inputB = 16'h4000;

            c111 = 16'h2000; c112 = 16'h2000; b11 = 16'h0000;
            c121 = 16'hE000; c122 = 16'hE000; b12 = 16'h0000;

            c211 = 16'h4000; c212 = 16'h0000; b21 = 16'h0000;
            c221 = 16'h0000; c222 = 16'h4000; b22 = 16'h0000;
            #1;

            check_outputs(16'hC000, 16'h4000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input sensitivity test", test_num);

            inputA = 16'hFFFF; inputB = 16'h0000;
            c111 = 16'h7FFF; c112 = 16'h0000; c121 = 16'h7FFF; c122 = 16'h0000;
            c211 = 16'h7FFF; c212 = 16'h7FFF; c221 = 16'h7FFF; c222 = 16'h7FFF;
            b11 = 16'h0000; b12 = 16'h0000; b21 = 16'h0000; b22 = 16'h0000;
            #1;

            check_outputs(16'hFFFF, 16'hFFFF);
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
        input [15:0] expected_out1;
        input [15:0] expected_out2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2)) begin
                $display("PASS");
                $display("  Outputs: out1=%h, out2=%h",
                         out1, out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h, out2=%h",
                         expected_out1, expected_out2);
                $display("  Got:      out1=%h, out2=%h",
                         out1, out2);
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
