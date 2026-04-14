`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] inval;
    wire [31:0] endian_twiddled_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inval(inval),
        .endian_twiddled_data(endian_twiddled_data)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple pattern 0x12345678", test_num);
            inval = 32'h12345678;
            #1;

            check_outputs(32'h78563412);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros", test_num);
            inval = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones", test_num);
            inval = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bytes AA/BB/CC/DD", test_num);
            inval = 32'hAABBCCDD;
            #1;

            check_outputs(32'hDDCCBBAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Least significant byte set", test_num);
            inval = 32'h000000FF;
            #1;

            check_outputs(32'hFF000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Most significant byte set", test_num);
            inval = 32'hFF000000;
            #1;

            check_outputs(32'h000000FF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Palindrome sequence", test_num);
            inval = 32'h11222211;
            #1;

            check_outputs(32'h11222211);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random pattern DEADBEEF", test_num);
            inval = 32'hDEADBEEF;
            #1;

            check_outputs(32'hEFBEADDE);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit in middle byte", test_num);
            inval = 32'h00008000;
            #1;

            check_outputs(32'h00800000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit pattern 0x55AA55AA", test_num);
            inval = 32'h55AA55AA;
            #1;

            check_outputs(32'hAA55AA55);
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
        input [31:0] expected_endian_twiddled_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_endian_twiddled_data === (expected_endian_twiddled_data ^ endian_twiddled_data ^ expected_endian_twiddled_data)) begin
                $display("PASS");
                $display("  Outputs: endian_twiddled_data=%h",
                         endian_twiddled_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: endian_twiddled_data=%h",
                         expected_endian_twiddled_data);
                $display("  Got:      endian_twiddled_data=%h",
                         endian_twiddled_data);
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
