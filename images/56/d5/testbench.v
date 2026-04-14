`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Ci;
    reg [3:0] G;
    reg [3:0] P;
    wire [2:0] C;
    wire Co;
    wire GG;
    wire PG;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Ci(Ci),
        .G(G),
        .P(P),
        .C(C),
        .Co(Co),
        .GG(GG),
        .PG(PG)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All Zeros", test_num);
        Ci = 0; G = 4'b0000; P = 4'b0000;

        #1;


        check_outputs(3'b000, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Pure Propagation", test_num);
        Ci = 1; G = 4'b0000; P = 4'b1111;


        #1;



        check_outputs(3'b111, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Generate at Bit 0 with Propagation", test_num);
        Ci = 0; G = 4'b0001; P = 4'b1110;





        #1;






        check_outputs(3'b111, 1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Generate at MSB", test_num);
        Ci = 0; G = 4'b1000; P = 4'b0000;


        #1;



        check_outputs(3'b000, 1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Generation in the middle", test_num);
        Ci = 0; G = 4'b0100; P = 4'b1011;






        #1;







        check_outputs(3'b100, 1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Group Propagate High", test_num);
        Ci = 0; G = 4'b0000; P = 4'b1111;


        #1;



        check_outputs(3'b000, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Mixed G and P", test_num);
        Ci = 1; G = 4'b0010; P = 4'b1001;







        #1;








        check_outputs(3'b011, 1'b0, 1'b0, 1'b0);
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
        input [2:0] expected_C;
        input expected_Co;
        input expected_GG;
        input expected_PG;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_Co === (expected_Co ^ Co ^ expected_Co) &&
                expected_GG === (expected_GG ^ GG ^ expected_GG) &&
                expected_PG === (expected_PG ^ PG ^ expected_PG)) begin
                $display("PASS");
                $display("  Outputs: C=%h, Co=%b, GG=%b, PG=%b",
                         C, Co, GG, PG);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h, Co=%b, GG=%b, PG=%b",
                         expected_C, expected_Co, expected_GG, expected_PG);
                $display("  Got:      C=%h, Co=%b, GG=%b, PG=%b",
                         C, Co, GG, PG);
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
