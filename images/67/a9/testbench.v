`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] Memory_data;
    wire [31:0] Sign_out_32;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Memory_data(Memory_data),
        .Sign_out_32(Sign_out_32)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            Memory_data = 32'h0000_0000;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            Memory_data = 32'hFFFF_FFFF;

            #1;


            check_outputs(32'h0000_00FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern 0x12345678", test_num);
            Memory_data = 32'h1234_5678;
            #1;

            check_outputs(32'h0000_0078);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern 0xAAAAAAAA", test_num);
            Memory_data = 32'hAAAA_AAAA;
            #1;

            check_outputs(32'h0000_00AA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern 0x55555555", test_num);
            Memory_data = 32'h5555_5555;
            #1;

            check_outputs(32'h0000_0055);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High bits set, low byte zero", test_num);
            Memory_data = 32'hFFFF_FF00;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random pattern 0xDEADC0DE", test_num);
            Memory_data = 32'hDEAD_C0DE;
            #1;

            check_outputs(32'h0000_00DE);
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
        input [31:0] expected_Sign_out_32;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Sign_out_32 === (expected_Sign_out_32 ^ Sign_out_32 ^ expected_Sign_out_32)) begin
                $display("PASS");
                $display("  Outputs: Sign_out_32=%h",
                         Sign_out_32);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Sign_out_32=%h",
                         expected_Sign_out_32);
                $display("  Got:      Sign_out_32=%h",
                         Sign_out_32);
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
