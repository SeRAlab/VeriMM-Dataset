`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] G2;
    reg [15:0] Pr2;
    wire [15:0] G3;
    wire [15:0] Pr3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .G2(G2),
        .Pr2(Pr2),
        .G3(G3),
        .Pr3(Pr3)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All Zeros", test_num);
            G2 = 16'h0000;
            Pr2 = 16'h0000;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: All Ones", test_num);
            G2 = 16'hFFFF;
            Pr2 = 16'hFFFF;
            #1;

            check_outputs(16'hFFFF, 16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Generate Propagation", test_num);
            G2 = 16'h000F;
            Pr2 = 16'hFFF0;



            #1;




            check_outputs(16'h00FF, 16'hFF00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Interleaved Pattern", test_num);
            G2 = 16'h5555;
            Pr2 = 16'hAAAA;







            #1;








            check_outputs(16'h5555, 16'hAAA0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Single Bit Shift", test_num);
            G2 = 16'h0001;
            Pr2 = 16'hFFFF;



            #1;




            check_outputs(16'h0011, 16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: High Bit Generate", test_num);
            G2 = 16'hF000;
            Pr2 = 16'h0FFF;


            #1;



            check_outputs(16'hF000, 16'h0FFF);
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
        input [15:0] expected_G3;
        input [15:0] expected_Pr3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_G3 === (expected_G3 ^ G3 ^ expected_G3) &&
                expected_Pr3 === (expected_Pr3 ^ Pr3 ^ expected_Pr3)) begin
                $display("PASS");
                $display("  Outputs: G3=%h, Pr3=%h",
                         G3, Pr3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: G3=%h, Pr3=%h",
                         expected_G3, expected_Pr3);
                $display("  Got:      G3=%h, Pr3=%h",
                         G3, Pr3);
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
