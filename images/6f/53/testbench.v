`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] In;
    reg [2:0] Pattern;
    wire [31:0] CountOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .In(In),
        .Pattern(Pattern),
        .CountOut(CountOut)
    );
    task testcase001;

        begin
            test_num = 1;
            In = 32'h00000000;
            Pattern = 3'b111;
            $display("Test %0d: No patterns present (All Zeros)", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            In = 32'h00000007;
            Pattern = 3'b111;
            $display("Test %0d: Single match at index 0", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            In = 32'hE0000000;
            Pattern = 3'b111;
            $display("Test %0d: Single match at index 29 (boundary)", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            In = 32'h0000000F;
            Pattern = 3'b111;
            $display("Test %0d: Overlapping matches (Indices 0 and 1)", test_num);
            #1;

            check_outputs(2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            In = 32'hFFFFFFFF;
            Pattern = 3'b111;
            $display("Test %0d: Maximum possible matches (All ones, Pattern 111)", test_num);

            #1;


            check_outputs(30);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            In = 32'h55555555;
            Pattern = 3'b010;
            $display("Test %0d: Alternating pattern 010", test_num);


            #1;



            check_outputs(15);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            In = 32'hAAAAAAAA;
            Pattern = 3'b101;
            $display("Test %0d: Alternating pattern 101", test_num);


            #1;



            check_outputs(15);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            In = 32'hFFFFFFFF;
            Pattern = 3'b000;
            $display("Test %0d: No matches in all ones for pattern 000", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            In = 32'h00000000;
            Pattern = 3'b000;
            $display("Test %0d: Maximum matches for pattern 000 in all zeros", test_num);
            #1;

            check_outputs(30);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            In = 32'h12492492;
            Pattern = 3'b001;
            $display("Test %0d: Sparse pattern matching", test_num);








            #1;









            check_outputs(10);
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
        testcase009();
        testcase010();
        
        
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
        input [31:0] expected_CountOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CountOut === (expected_CountOut ^ CountOut ^ expected_CountOut)) begin
                $display("PASS");
                $display("  Outputs: CountOut=%h",
                         CountOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CountOut=%h",
                         expected_CountOut);
                $display("  Got:      CountOut=%h",
                         CountOut);
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
