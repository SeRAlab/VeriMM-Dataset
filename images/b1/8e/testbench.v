`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] Address;
    wire [31:0] Data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Address(Address),
        .Data(Data)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking Address 0 (First Entry)", test_num);
            Address = 64'd0;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking Address 10 (Middle Entry)", test_num);
            Address = 64'd10;

            #1;


            check_outputs(32'h0000000A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking Address 39 (Last Entry)", test_num);
            Address = 64'd39;

            #1;


            check_outputs(32'h00000027);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking Address 40 (Out of Bounds - Boundary)", test_num);
            Address = 64'd40;

            #1;


            check_outputs(32'hXXXXXXXX);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking Address 0xFFFFFFFFFFFFFFFF (Out of Bounds - Far)", test_num);
            Address = 64'hFFFFFFFFFFFFFFFF;

            #1;


            check_outputs(32'hXXXXXXXX);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking Address 1024 (Invalid)", test_num);
            Address = 64'd1024;
            #1;

            check_outputs(32'hXXXXXXXX);
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
        input [31:0] expected_Data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Data === (expected_Data ^ Data ^ expected_Data)) begin
                $display("PASS");
                $display("  Outputs: Data=%h",
                         Data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Data=%h",
                         expected_Data);
                $display("  Got:      Data=%h",
                         Data);
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
