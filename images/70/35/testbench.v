`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] g;
    reg [15:0] p;
    wire [15:0] G1;
    wire [15:0] Pr1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .g(g),
        .p(p),
        .G1(G1),
        .Pr1(Pr1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            g = 16'h0000;
            p = 16'h0000;



            #1;




            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            g = 16'hFFFF;
            p = 16'hFFFF;



            #1;




            check_outputs(16'hFFFF, 16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            g = 16'h0001;
            p = 16'hFFFE;





            #1;






            check_outputs(16'h0003, 16'hFFFC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            g = 16'h5555;
            p = 16'hAAAA;





            #1;






            check_outputs(16'hFFFF, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            g = 16'h00FF;
            p = 16'hFF00;





            #1;






            check_outputs(16'h01FF, 16'hFE00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            g = 16'h8000;
            p = 16'h0000;


            #1;



            check_outputs(16'h8000, 16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            g = 16'h0000;
            p = 16'hFFFF;


            #1;



            check_outputs(16'h0000, 16'hFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            g = 16'hCCCC;
            p = 16'h3333;





            #1;






            check_outputs(16'hCCCC, 16'h3333);
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
        input [15:0] expected_G1;
        input [15:0] expected_Pr1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_G1 === (expected_G1 ^ G1 ^ expected_G1) &&
                expected_Pr1 === (expected_Pr1 ^ Pr1 ^ expected_Pr1)) begin
                $display("PASS");
                $display("  Outputs: G1=%h, Pr1=%h",
                         G1, Pr1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: G1=%h, Pr1=%h",
                         expected_G1, expected_Pr1);
                $display("  Got:      G1=%h, Pr1=%h",
                         G1, Pr1);
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
