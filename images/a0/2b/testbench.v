`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [30:0] a;
    wire [63:0] b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Zero", test_num);
            a = 31'h0;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input One", test_num);
            a = 31'h1;

            #1;


            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Maximum (All 31 bits set)", test_num);
            a = 31'h7FFFFFFF;



            #1;




            check_outputs(64'hFFFFFFFF80000001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 2", test_num);
            a = 31'h2;

            #1;


            check_outputs(64'hFFFFFFFFFFFFFFFE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Bit 30 set (0x40000000)", test_num);
            a = 31'h40000000;



            #1;




            check_outputs(64'hFFFFFFFFC0000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Random Pattern 0x12345678", test_num);
            a = 31'h12345678;



            #1;




            check_outputs(64'hFFFFFFFFEDCBA988);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Alternating Bits", test_num);
            a = 31'h55555555;



            #1;




            check_outputs(64'hFFFFFFFFAAAAAAAB);
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
        input [63:0] expected_b;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_b === (expected_b ^ b ^ expected_b)) begin
                $display("PASS");
                $display("  Outputs: b=%h",
                         b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b=%h",
                         expected_b);
                $display("  Got:      b=%h",
                         b);
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
