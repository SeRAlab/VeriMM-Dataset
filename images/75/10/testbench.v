`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] G2;
    reg [31:0] Pr2;
    wire [31:0] G3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .G2(G2),
        .Pr2(Pr2),
        .G3(G3)
    );
    task testcase001;

    begin
        test_num = 1;
        G2 = 32'h00000000;
        Pr2 = 32'h00000000;
        #1;

        check_outputs(ref_model(G2, Pr2));
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        G2 = 32'hFFFFFFFF;
        Pr2 = 32'hFFFFFFFF;
        #1;

        check_outputs(ref_model(G2, Pr2));
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        G2 = 32'hAAAAAAAA;
        Pr2 = 32'h55555555;
        #1;

        check_outputs(ref_model(G2, Pr2));
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        G2 = 32'h00000001;
        Pr2 = 32'h00000010;

        #1;


        check_outputs(ref_model(G2, Pr2));
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        G2 = 32'h0000000F;
        Pr2 = 32'h000000F0;

        #1;


        check_outputs(ref_model(G2, Pr2));
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        G2 = 32'h0F0F0F0F;
        Pr2 = 32'hF0F0F0F0;

        #1;


        check_outputs(ref_model(G2, Pr2));
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        G2 = 32'h12345678;
        Pr2 = 32'h87654321;
        #1;

        check_outputs(ref_model(G2, Pr2));
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        G2 = 32'hDEADBEEF;
        Pr2 = 32'hCAFEBABE;
        #1;

        check_outputs(ref_model(G2, Pr2));
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
        input [31:0] expected_G3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_G3 === (expected_G3 ^ G3 ^ expected_G3)) begin
                $display("PASS");
                $display("  Outputs: G3=%h",
                         G3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: G3=%h",
                         expected_G3);
                $display("  Got:      G3=%h",
                         G3);
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
