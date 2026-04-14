`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] inputSelect;
    reg [543:0] inputState;
    wire configInvalid;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inputSelect(inputSelect),
        .inputState(inputState),
        .configInvalid(configInvalid),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            inputState = 544'h0;
            inputState[31:0] = 32'hAAAA_BBBB;
            inputSelect = 5'd0;

            #1;


            check_outputs(1'b0, 32'hAAAA_BBBB);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            inputState = 544'h0;

            inputState[543:512] = 32'h1234_5678;
            inputSelect = 5'd16;

            #1;


            check_outputs(1'b0, 32'h1234_5678);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            inputState = 544'h0;

            inputState[287:256] = 32'hCAFE_BABE;
            inputSelect = 5'd8;

            #1;


            check_outputs(1'b0, 32'hCAFE_BABE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            inputState = {17{32'hFFFF_FFFF}};
            inputSelect = 5'd17;


            #1;



            check_outputs(1'b1, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            inputState = 544'hF0F0F0F0_E0E0E0E0;
            inputSelect = 5'd31;

            #1;


            check_outputs(1'b1, 32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            inputState = 544'h0;

            inputState[191:160] = 32'hDEAD_BEEF;
            inputSelect = 5'd5;
            #1;

            check_outputs(1'b0, 32'hDEAD_BEEF);
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
        input expected_configInvalid;
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_configInvalid === (expected_configInvalid ^ configInvalid ^ expected_configInvalid) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: configInvalid=%b, out=%h",
                         configInvalid, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: configInvalid=%b, out=%h",
                         expected_configInvalid, expected_out);
                $display("  Got:      configInvalid=%b, out=%h",
                         configInvalid, out);
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
