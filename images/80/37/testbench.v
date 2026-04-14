`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] DATA_A;
    reg [63:0] DATA_B;
    reg SELECTOR;
    wire [63:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DATA_A(DATA_A),
        .DATA_B(DATA_B),
        .SELECTOR(SELECTOR),
        .OUT(OUT)
    );
    task testcase001;

        begin
            test_num = 1;
            SELECTOR = 1'b0;
            DATA_A = 64'hFEDCBA9876543210;
            DATA_B = 64'h0123456789ABCDEF;
            #1;

            check_outputs(64'hFEDCBA9876543210);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            SELECTOR = 1'b1;
            DATA_A = 64'hFEDCBA9876543210;
            DATA_B = 64'h0123456789ABCDEF;
            #1;

            check_outputs(64'h0123456789ABCDEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            SELECTOR = 1'b0;
            DATA_A = 64'hFFFFFFFFFFFFFFFF;
            DATA_B = 64'h0000000000000000;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            SELECTOR = 1'b1;
            DATA_A = 64'hFFFFFFFFFFFFFFFF;
            DATA_B = 64'h0000000000000000;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            SELECTOR = 1'b1;
            DATA_A = 64'h5555555555555555;
            DATA_B = 64'hAAAAAAAAAAAAAAAA;
            #1;

            check_outputs(64'hAAAAAAAAAAAAAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            SELECTOR = 1'b0;
            DATA_A = 64'h8000000000000001;
            DATA_B = 64'h7FFFFFFFFFFFFFFE;
            #1;

            check_outputs(64'h8000000000000001);
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
        input [63:0] expected_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h",
                         expected_OUT);
                $display("  Got:      OUT=%h",
                         OUT);
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
