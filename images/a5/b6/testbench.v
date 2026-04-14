`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    reg E;
    reg F;
    reg G;
    reg H;
    reg I;
    wire Y;

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
        .I(I),
        .Y(Y)
    );
    task testcase001;

    begin
        {A, B, C, D, E, F, G, H, I} = 9'b111_000_001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        {A, B, C, D, E, F, G, H, I} = 9'b000_111_001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        {A, B, C, D, E, F, G, H, I} = 9'b111_111_001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        {A, B, C, D, E, F, G, H, I} = 9'b101_111_001;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        {A, B, C, D, E, F, G, H, I} = 9'b111_101_001;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        {A, B, C, D, E, F, G, H, I} = 9'b111_000_101;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        {A, B, C, D, E, F, G, H, I} = 9'b111_000_011;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        {A, B, C, D, E, F, G, H, I} = 9'b111_000_000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        {A, B, C, D, E, F, G, H, I} = 9'b000_000_001;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        {A, B, C, D, E, F, G, H, I} = 9'b010_000_001;
        #1;

        check_outputs(1'b0);
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
