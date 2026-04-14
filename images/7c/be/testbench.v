`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] G4;
    reg [31:0] Pr4;
    wire [31:0] G5;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .G4(G4),
        .Pr4(Pr4),
        .G5(G5)
    );
    task testcase001;

    begin
        test_num = 1;
        G4 = 32'h0000_0000;
        Pr4 = 32'h0000_0000;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        G4 = 32'hFFFF_FFFF;
        Pr4 = 32'hFFFF_FFFF;

        #1;


        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        G4 = 32'hA5A5_A5A5;
        Pr4 = 32'h0000_0000;
        #1;

        check_outputs(32'hA5A5_A5A5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        G4 = 32'h0000_FFFF;
        Pr4 = 32'hFFFF_0000;

        #1;


        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        G4 = 32'h0000_FFFF;
        Pr4 = 32'h0000_FFFF;
        #1;

        check_outputs(32'h0000_FFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        G4 = 32'h5555_5555;
        Pr4 = 32'hAAAA_AAAA;


        #1;



        check_outputs(32'h5555_5555);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        G4  = 32'h1234_5678;
        Pr4 = 32'hFFFF_0000;


        #1;



        check_outputs(32'h567C_5678);
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
        input [31:0] expected_G5;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_G5 === (expected_G5 ^ G5 ^ expected_G5)) begin
                $display("PASS");
                $display("  Outputs: G5=%h",
                         G5);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: G5=%h",
                         expected_G5);
                $display("  Got:      G5=%h",
                         G5);
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
