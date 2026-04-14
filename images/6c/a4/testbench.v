`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] b_out;
    reg [1:0] controleSS;
    reg [31:0] dataRegOut;
    wire [31:0] ss_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b_out(b_out),
        .controleSS(controleSS),
        .dataRegOut(dataRegOut),
        .ss_out(ss_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Case 0 - Direct b_out passthrough", test_num);
            controleSS = 2'b00;
            dataRegOut = 32'hAAAA_BBBB;
            b_out = 32'h1234_5678;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Case 1 - Byte manipulation (8-bit b_out)", test_num);
            controleSS = 2'b01;
            dataRegOut = 32'h1122_3344;
            b_out = 32'hFFFF_FFAA;

            #1;


            check_outputs(32'h1122_33AA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Case 2 - Halfword manipulation (16-bit b_out)", test_num);
            controleSS = 2'b10;
            dataRegOut = 32'hAAAA_BBBB;
            b_out = 32'hCCCC_DDDD;

            #1;


            check_outputs(32'hAAAA_DDDD);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Case 0 - Full 32-bit check", test_num);
            controleSS = 2'b00;
            dataRegOut = 32'h0000_0000;
            b_out = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Case 1 - Boundary check", test_num);
            controleSS = 2'b01;
            dataRegOut = 32'hFFFF_FF00;
            b_out = 32'h0000_00FF;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Case 2 - Zero check", test_num);
            controleSS = 2'b10;
            dataRegOut = 32'h0000_FFFF;
            b_out = 32'hFFFF_0000;
            #1;

            check_outputs(32'h0000_0000);
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
        input [31:0] expected_ss_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ss_out === (expected_ss_out ^ ss_out ^ expected_ss_out)) begin
                $display("PASS");
                $display("  Outputs: ss_out=%h",
                         ss_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ss_out=%h",
                         expected_ss_out);
                $display("  Got:      ss_out=%h",
                         ss_out);
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
