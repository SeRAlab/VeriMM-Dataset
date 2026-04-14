`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] g;
    reg [31:0] p;
    wire [31:0] G1;
    wire [31:0] Pr1;

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
        $display("Test Case %0d: All Zeros", test_num);
        g = 32'h00000000;
        p = 32'h00000000;
        #1;

        check_outputs(32'h00000000, 32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Ones", test_num);
        g = 32'hFFFFFFFF;
        p = 32'hFFFFFFFF;


        #1;



        check_outputs(32'hFFFFFFFF, 32'hFFFFFFFE);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Pattern 1 (Generate focus)", test_num);
        g = 32'h55555555;
        p = 32'hAAAAAAAA;




        #1;





        check_outputs(32'hFFFFFFFF, 32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Pattern 2 (Propagate focus)", test_num);
        g = 32'hAAAAAAAA;
        p = 32'h55555555;




        #1;





        check_outputs(32'hFFFFFFFE, 32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sparse Blocks", test_num);
        g = 32'h0000FFFF;
        p = 32'hFFFF0000;





        #1;






        check_outputs(32'h0001FFFF, 32'hFFFE0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single Bit Shift Check", test_num);
        g = 32'h00000001;
        p = 32'h00000002;




        #1;





        check_outputs(32'h00000003, 32'h00000000);
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
        input [31:0] expected_G1;
        input [31:0] expected_Pr1;
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
