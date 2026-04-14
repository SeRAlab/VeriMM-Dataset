`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg MemtoRegSel;
    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] Result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .MemtoRegSel(MemtoRegSel),
        .a(a),
        .b(b),
        .Result(Result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select input 'a' (MemtoRegSel = 0)", test_num);
            a = 32'hAAAA_BBBB;
            b = 32'h1111_2222;
            MemtoRegSel = 0;
            #1;

            check_outputs(32'hAAAA_BBBB);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select input 'b' (MemtoRegSel = 1)", test_num);
            a = 32'hAAAA_BBBB;
            b = 32'h1111_2222;
            MemtoRegSel = 1;
            #1;

            check_outputs(32'h1111_2222);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: All zeros on selected input 'a'", test_num);
            a = 32'h0000_0000;
            b = 32'hFFFF_FFFF;
            MemtoRegSel = 0;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: All ones on selected input 'b'", test_num);
            a = 32'h0000_0000;
            b = 32'hFFFF_FFFF;
            MemtoRegSel = 1;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Alternating bit patterns - Select 'a'", test_num);
            a = 32'h5555_5555;
            b = 32'hAAAA_AAAA;
            MemtoRegSel = 0;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Alternating bit patterns - Select 'b'", test_num);
            a = 32'h5555_5555;
            b = 32'hAAAA_AAAA;
            MemtoRegSel = 1;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Random data pattern test", test_num);
            a = 32'h1234_5678;
            b = 32'h8765_4321;
            MemtoRegSel = 0;
            #1;

            check_outputs(32'h1234_5678);
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
        input [31:0] expected_Result;
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
