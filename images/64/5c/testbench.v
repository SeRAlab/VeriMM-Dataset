`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg EXTsle;
    reg [15:0] i16;
    wire [31:0] EXTOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EXTsle(EXTsle),
        .i16(i16),
        .EXTOUT(EXTOUT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Zero Extension, positive MSB", test_num);
            EXTsle = 1'b1;
            i16 = 16'h7ABC;
            #1;

            check_outputs(32'h00007ABC);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Zero Extension, negative MSB", test_num);
            EXTsle = 1'b1;
            i16 = 16'h8ABC;
            #1;

            check_outputs(32'h00008ABC);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sign Extension, positive MSB", test_num);
            EXTsle = 1'b0;
            i16 = 16'h1234;
            #1;

            check_outputs(32'h00001234);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sign Extension, negative MSB", test_num);
            EXTsle = 1'b0;
            i16 = 16'hF00D;
            #1;

            check_outputs(32'hFFFFF00D);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Zero Extension, All Ones", test_num);
            EXTsle = 1'b1;
            i16 = 16'hFFFF;
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sign Extension, All Ones", test_num);
            EXTsle = 1'b0;
            i16 = 16'hFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Zero Extension, All Zeros", test_num);
            EXTsle = 1'b1;
            i16 = 16'h0000;
            #1;

            check_outputs(32'h00000000);
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
        input [31:0] expected_EXTOUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EXTOUT === (expected_EXTOUT ^ EXTOUT ^ expected_EXTOUT)) begin
                $display("PASS");
                $display("  Outputs: EXTOUT=%h",
                         EXTOUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EXTOUT=%h",
                         expected_EXTOUT);
                $display("  Got:      EXTOUT=%h",
                         EXTOUT);
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
