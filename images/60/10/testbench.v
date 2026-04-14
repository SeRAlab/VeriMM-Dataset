`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] G1;
    reg [15:0] Pr1;
    wire [15:0] G2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .G1(G1),
        .Pr1(Pr1),
        .G2(G2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros", test_num);
            G1 = 16'h0000;
            Pr1 = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones", test_num);
            G1 = 16'hFFFF;
            Pr1 = 16'hFFFF;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pass-through (Pr1=0)", test_num);
            G1 = 16'h1234;
            Pr1 = 16'h0000;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bit 0 to 1 propagation", test_num);
            G1 = 16'h0001;
            Pr1 = 16'hFFFF;
            #1;

            check_outputs(16'h0003);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Interleaved bits", test_num);
            G1 = 16'hAAAA;
            Pr1 = 16'h5555;
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: MSB propagation (Bit 14 to 15)", test_num);
            G1 = 16'h4000;
            Pr1 = 16'h8000;
            #1;

            check_outputs(16'hC000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Half-nibble patterns", test_num);
            G1 = 16'h0F0F;
            Pr1 = 16'hF0F0;
            #1;

            check_outputs(16'h1F1F);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Block propagation", test_num);
            G1 = 16'h00FF;
            Pr1 = 16'hFF00;
            #1;

            check_outputs(16'h01FF);
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
        input [15:0] expected_G2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_G2 === (expected_G2 ^ G2 ^ expected_G2)) begin
                $display("PASS");
                $display("  Outputs: G2=%h",
                         G2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: G2=%h",
                         expected_G2);
                $display("  Got:      G2=%h",
                         G2);
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
