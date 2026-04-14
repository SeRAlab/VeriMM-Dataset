`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    wire [15:0] G1;
    wire [15:0] Pr1;
    wire [15:0] g;
    wire [15:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .G1(G1),
        .Pr1(Pr1),
        .g(g),
        .p(p)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a = 16'h0000;
            b = 16'h0000;

            #1;


            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 16'hFFFF;
            b = 16'hFFFF;

            #1;


            check_outputs(16'hFFFF, 16'hFFFF, 16'hFFFF, 16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 16'hAAAA;
            b = 16'h5555;


            #1;



            check_outputs(16'h0000, 16'hFFFF, 16'h0000, 16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 16'hF0F0;
            b = 16'hCCCC;


            #1;



            check_outputs(16'hC0C0, 16'hFCFC, 16'hC0C0, 16'hFCFC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 16'hFF00;
            b = 16'h00FF;

            #1;


            check_outputs(16'h0000, 16'hFFFF, 16'h0000, 16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a = 16'h1234;
            b = 16'h5678;




            #1;





            check_outputs(16'h1230, 16'h567C, 16'h1230, 16'h567C);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            a = 16'h8000;
            b = 16'h8000;

            #1;


            check_outputs(16'h8000, 16'h8000, 16'h8000, 16'h8000);
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
        input [15:0] expected_G1;
        input [15:0] expected_Pr1;
        input [15:0] expected_g;
        input [15:0] expected_p;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_G1 === (expected_G1 ^ G1 ^ expected_G1) &&
                expected_Pr1 === (expected_Pr1 ^ Pr1 ^ expected_Pr1) &&
                expected_g === (expected_g ^ g ^ expected_g) &&
                expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: G1=%h, Pr1=%h, g=%h, p=%h",
                         G1, Pr1, g, p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: G1=%h, Pr1=%h, g=%h, p=%h",
                         expected_G1, expected_Pr1, expected_g, expected_p);
                $display("  Got:      G1=%h, Pr1=%h, g=%h, p=%h",
                         G1, Pr1, g, p);
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
