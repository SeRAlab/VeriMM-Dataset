`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] Data_A;
    reg [63:0] Data_B;
    wire [63:0] Result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Data_A(Data_A),
        .Data_B(Data_B),
        .Result(Result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero addition", test_num);
            Data_A = 64'h0;
            Data_B = 64'h0;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple addition", test_num);
            Data_A = 64'h0000_0000_0000_0005;
            Data_B = 64'h0000_0000_0000_000A;
            #1;

            check_outputs(64'h0000_0000_0000_000F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum value plus zero", test_num);
            Data_A = 64'hFFFF_FFFF_FFFF_FFFF;
            Data_B = 64'h0000_0000_0000_0000;
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow wrap-around (Max + 1)", test_num);
            Data_A = 64'hFFFF_FFFF_FFFF_FFFF;
            Data_B = 64'h0000_0000_0000_0001;
            #1;

            check_outputs(64'h0000_0000_0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit pattern AAAA + 5555", test_num);
            Data_A = 64'hAAAA_AAAA_AAAA_AAAA;
            Data_B = 64'h5555_5555_5555_5555;
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large number addition with carry propagation", test_num);
            Data_A = 64'h1234_5678_9ABC_DEF0;
            Data_B = 64'hEDCB_A987_6543_210F;
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random addition 1", test_num);
            Data_A = 64'h0000_1111_2222_3333;
            Data_B = 64'h4444_5555_6666_7777;
            #1;

            check_outputs(64'h4444_6666_8888_AAAA);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-point carry", test_num);
            Data_A = 64'h0000_0000_FFFF_FFFF;
            Data_B = 64'h0000_0000_0000_0001;
            #1;

            check_outputs(64'h0000_0001_0000_0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High-bit addition", test_num);
            Data_A = 64'h8000_0000_0000_0000;
            Data_B = 64'h8000_0000_0000_0000;
            #1;

            check_outputs(64'h0000_0000_0000_0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed bits", test_num);
            Data_A = 64'hFEDC_BA98_7654_3210;
            Data_B = 64'h0123_4567_89AB_CDEF;
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
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
        input [63:0] expected_Result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Result === (expected_Result ^ Result ^ expected_Result)) begin
                $display("PASS");
                $display("  Outputs: Result=%h",
                         Result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Result=%h",
                         expected_Result);
                $display("  Got:      Result=%h",
                         Result);
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
