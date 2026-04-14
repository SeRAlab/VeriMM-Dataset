`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] G1;
    reg [31:0] Pr1;
    wire [31:0] G2;
    wire [31:0] Pr2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .G1(G1),
        .Pr1(Pr1),
        .G2(G2),
        .Pr2(Pr2)
    );
    task testcase001;

        begin
            test_num = 1;
            G1 = 32'h0000_0000;
            Pr1 = 32'h0000_0000;
            #1;

            check_outputs(32'h0000_0000, 32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            G1 = 32'hFFFF_FFFF;
            Pr1 = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'hFFFF_FFFF, 32'hFFFF_FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            G1 = 32'h0000_0001;
            Pr1 = 32'hFFFF_FFFF;


            #1;



            check_outputs(32'hFFFF_FFFF, 32'hFFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            G1 = 32'h5555_5555;
            Pr1 = 32'hAAAA_AAAA;




            #1;





            check_outputs(32'hFFFF_FFFF, 32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            G1 = 32'hAAAA_AAAA;
            Pr1 = 32'h5555_5555;





            #1;






            check_outputs(32'hAAAA_AAAA, 32'h0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            G1 = 32'h0000_1000;
            Pr1 = 32'h0000_F000;


            #1;



            check_outputs(32'h0000_F000, 32'h0000_E000);
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
        input [31:0] expected_G2;
        input [31:0] expected_Pr2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_G2 === (expected_G2 ^ G2 ^ expected_G2) &&
                expected_Pr2 === (expected_Pr2 ^ Pr2 ^ expected_Pr2)) begin
                $display("PASS");
                $display("  Outputs: G2=%h, Pr2=%h",
                         G2, Pr2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: G2=%h, Pr2=%h",
                         expected_G2, expected_Pr2);
                $display("  Got:      G2=%h, Pr2=%h",
                         G2, Pr2);
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
