`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] PCin;
    reg [31:0] branch;
    reg [2:0] control;
    reg [31:0] jimmediate;
    reg [31:0] jreg;
    reg zero;
    wire [15:0] PCout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PCin(PCin),
        .branch(branch),
        .control(control),
        .jimmediate(jimmediate),
        .jreg(jreg),
        .zero(zero),
        .PCout(PCout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequential Increment (control=0)", test_num);
            PCin = 16'h1000;
            control = 3'b000;
            branch = 32'h0000_0004;
            jimmediate = 32'h0000_2000;
            jreg = 32'h0000_3000;
            zero = 1'b0;

            #1;


            check_outputs(16'h1001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Conditional Branch Taken (control=1, zero=1)", test_num);
            PCin = 16'h2000;
            control = 3'b001;
            branch = 32'h0000_0008;
            zero = 1'b1;

            #1;


            check_outputs(16'h2008);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Conditional Branch Not Taken (control=1, zero=0)", test_num);
            PCin = 16'h2000;
            control = 3'b001;
            branch = 32'h0000_0008;
            zero = 1'b0;

            #1;


            check_outputs(16'h2001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Jump Immediate (control=2)", test_num);
            PCin = 16'h0000;
            control = 3'b010;
            jimmediate = 32'h0000_ABCD;

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Jump Register (control=3)", test_num);
            PCin = 16'h1234;
            control = 3'b011;
            jreg = 32'h0000_5678;

            #1;


            check_outputs(16'h5678);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Backward Branch (control=1, zero=1, negative branch)", test_num);
            PCin = 16'h1010;
            control = 3'b001;
            branch = 32'hFFFF_FFF0;
            zero = 1'b1;

            #1;


            check_outputs(16'h1000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Address Truncation (32-bit to 16-bit)", test_num);
            PCin = 16'h0000;
            control = 3'b010;
            jimmediate = 32'h1234_5678;

            #1;


            check_outputs(16'h5678);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: PC Overflow Wrap-around", test_num);
            PCin = 16'hFFFF;
            control = 3'b000;

            #1;


            check_outputs(16'h0000);
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
        input [15:0] expected_PCout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_PCout === (expected_PCout ^ PCout ^ expected_PCout)) begin
                $display("PASS");
                $display("  Outputs: PCout=%h",
                         PCout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PCout=%h",
                         expected_PCout);
                $display("  Got:      PCout=%h",
                         PCout);
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
