`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] E_i;
    wire [31:0] sigma_1_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .E_i(E_i),
        .sigma_1_o(sigma_1_o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            E_i = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            E_i = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit (LSB)", test_num);
            E_i = 32'h00000001;



            #1;




            check_outputs(32'h04200080);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit (MSB)", test_num);
            E_i = 32'h80000000;



            #1;




            check_outputs(32'h02100040);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Standard SHA-256 H0 Constant", test_num);
            E_i = 32'h6a09e667;




            #1;





            check_outputs(32'h1c4e7325);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Pattern A", test_num);
            E_i = 32'hAAAAAAAA;




            #1;





            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary Pattern", test_num);
            E_i = 32'h12345678;




            #1;





            check_outputs(32'ha44e1ac6);
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
        input [31:0] expected_sigma_1_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sigma_1_o === (expected_sigma_1_o ^ sigma_1_o ^ expected_sigma_1_o)) begin
                $display("PASS");
                $display("  Outputs: sigma_1_o=%h",
                         sigma_1_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sigma_1_o=%h",
                         expected_sigma_1_o);
                $display("  Got:      sigma_1_o=%h",
                         sigma_1_o);
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
