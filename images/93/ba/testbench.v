`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire [31:0] g;
    wire [31:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .g(g),
        .p(p)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All zeros", test_num);
        A = 32'h00000000;
        B = 32'h00000000;
        #1;

        check_outputs(32'h00000000, 32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All ones", test_num);
        A = 32'hFFFFFFFF;
        B = 32'hFFFFFFFF;

        #1;


        check_outputs(32'hFFFFFFFF, 32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Complementary patterns", test_num);
        A = 32'hAAAAAAAA;
        B = 32'h55555555;

        #1;


        check_outputs(32'h00000000, 32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: XOR with 0 identity", test_num);
        A = 32'h12345678;
        B = 32'h00000000;

        #1;


        check_outputs(32'h00000000, 32'h12345678);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Specific hex pattern", test_num);
        A = 32'h0F0F0F0F;
        B = 32'h00FF00FF;

        #1;


        check_outputs(32'h000F000F, 32'h0FF00FF0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mixed bits", test_num);
        A = 32'h12345678;
        B = 32'h87654321;

        #1;


        check_outputs(32'h02244220, 32'h95511559);
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
        input [31:0] expected_g;
        input [31:0] expected_p;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_g === (expected_g ^ g ^ expected_g) &&
                expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: g=%h, p=%h",
                         g, p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: g=%h, p=%h",
                         expected_g, expected_p);
                $display("  Got:      g=%h, p=%h",
                         g, p);
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
