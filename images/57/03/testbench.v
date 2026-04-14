`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] ALU_out;
    reg M4;
    reg [15:0] Shift_out;
    wire [15:0] MUX_4_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_out(ALU_out),
        .M4(M4),
        .Shift_out(Shift_out),
        .MUX_4_out(MUX_4_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select ALU_out (M4=0)", test_num);
            ALU_out = 16'hAAAA;
            Shift_out = 16'h5555;
            M4 = 1'b0;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select Shift_out (M4=1)", test_num);
            ALU_out = 16'hAAAA;
            Shift_out = 16'h5555;
            M4 = 1'b1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select All Ones from ALU_out (M4=0)", test_num);
            ALU_out = 16'hFFFF;
            Shift_out = 16'h0000;
            M4 = 1'b0;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select All Zeros from Shift_out (M4=1)", test_num);
            ALU_out = 16'hFFFF;
            Shift_out = 16'h0000;
            M4 = 1'b1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Select Arbitrary Value from ALU_out (M4=0)", test_num);
            ALU_out = 16'h1234;
            Shift_out = 16'hEDCB;
            M4 = 1'b0;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Select Arbitrary Value from Shift_out (M4=1)", test_num);
            ALU_out = 16'h1234;
            Shift_out = 16'hEDCB;
            M4 = 1'b1;
            #1;

            check_outputs(16'hEDCB);
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
        input [15:0] expected_MUX_4_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_MUX_4_out === (expected_MUX_4_out ^ MUX_4_out ^ expected_MUX_4_out)) begin
                $display("PASS");
                $display("  Outputs: MUX_4_out=%h",
                         MUX_4_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MUX_4_out=%h",
                         expected_MUX_4_out);
                $display("  Got:      MUX_4_out=%h",
                         MUX_4_out);
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
