`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A_i;
    reg [31:0] B_i;
    reg [31:0] C_i;
    wire [31:0] maj_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A_i(A_i),
        .B_i(B_i),
        .C_i(C_i),
        .maj_o(maj_o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            A_i = 32'h00000000;
            B_i = 32'h00000000;
            C_i = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            A_i = 32'hFFFFFFFF;
            B_i = 32'hFFFFFFFF;
            C_i = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Two Inputs All Ones, One Input Zero", test_num);
            A_i = 32'hFFFFFFFF;
            B_i = 32'hFFFFFFFF;
            C_i = 32'h00000000;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: One Input All Ones, Two Inputs Zero", test_num);
            A_i = 32'hFFFFFFFF;
            B_i = 32'h00000000;
            C_i = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise Checkerboard Patterns", test_num);


            A_i = 32'hAAAAAAAA;
            B_i = 32'h55555555;
            C_i = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Nibble Pattern", test_num);

            A_i = 32'hF0F0F0F0;
            B_i = 32'hFF00FF00;
            C_i = 32'hFFFF0000;





            #1;






            check_outputs(32'hFFF0F000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Hex Pattern 1", test_num);
            A_i = 32'h12345678;
            B_i = 32'h9ABCDEF0;
            C_i = 32'hFFFF0000;






            #1;







            check_outputs(32'h9ABF5670);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Inverse Checkerboard", test_num);
            A_i = 32'h55555555;
            B_i = 32'hAAAAAAAA;
            C_i = 32'h00000000;

            #1;


            check_outputs(32'h00000000);
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
        input [31:0] expected_maj_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_maj_o === (expected_maj_o ^ maj_o ^ expected_maj_o)) begin
                $display("PASS");
                $display("  Outputs: maj_o=%h",
                         maj_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: maj_o=%h",
                         expected_maj_o);
                $display("  Got:      maj_o=%h",
                         maj_o);
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
