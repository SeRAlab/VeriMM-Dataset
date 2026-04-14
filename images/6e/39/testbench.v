`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] search;
    wire [15:0] match;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .search(search),
        .match(match)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Searching for All Zeros", test_num);
            search = 32'h00000000;


            #1;



            check_outputs(16'h0001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Searching for All Ones", test_num);
            search = 32'hFFFFFFFF;


            #1;



            check_outputs(16'h0002);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Searching for Alternating Bit Pattern A", test_num);
            search = 32'hAAAAAAAA;


            #1;



            check_outputs(16'h0004);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Searching for Alternating Bit Pattern 5", test_num);
            search = 32'h55555555;


            #1;



            check_outputs(16'h0008);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Searching for Incrementing Hex Pattern", test_num);
            search = 32'h12345678;


            #1;



            check_outputs(16'h0010);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Searching for Known Constant (DEADBEEF)", test_num);
            search = 32'hDEADBEEF;


            #1;



            check_outputs(16'h0020);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Searching for Non-existent Pattern", test_num);
            search = 32'hBADC0FFE;


            #1;



            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Searching for Pattern with MSB Only", test_num);
            search = 32'h80000000;

            #1;


            check_outputs(16'h0040);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Searching for Pattern with LSB Only", test_num);
            search = 32'h00000001;

            #1;


            check_outputs(16'h0080);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Searching for Symmetric Pattern", test_num);
            search = 32'hC0000003;

            #1;


            check_outputs(16'h0100);
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
        input [15:0] expected_match;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_match === (expected_match ^ match ^ expected_match)) begin
                $display("PASS");
                $display("  Outputs: match=%h",
                         match);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: match=%h",
                         expected_match);
                $display("  Got:      match=%h",
                         match);
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
