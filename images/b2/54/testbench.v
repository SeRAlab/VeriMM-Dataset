`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg control;
    reg [5:0] m;
    reg [5:0] n;
    wire [5:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .control(control),
        .m(m),
        .n(n),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: control=0 (XOR), m=0, n=0", test_num);
            control = 1'b0;
            m = 6'h00;
            n = 6'h00;
            #1;

            check_outputs(6'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: control=0 (XOR), m=all ones, n=0", test_num);
            control = 1'b0;
            m = 6'h3F;
            n = 6'h00;
            #1;

            check_outputs(6'h3F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: control=0 (XOR), m=0, n=all ones", test_num);
            control = 1'b0;
            m = 6'h00;
            n = 6'h3F;
            #1;

            check_outputs(6'h3F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: control=0 (XOR), m=alternate, n=alternate", test_num);
            control = 1'b0;
            m = 6'b101010;
            n = 6'b010101;
            #1;

            check_outputs(6'b111111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: control=0 (XOR), m=n", test_num);
            control = 1'b0;
            m = 6'h12;
            n = 6'h12;
            #1;

            check_outputs(6'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: control=1 (NOT), m=0", test_num);
            control = 1'b1;
            m = 6'h00;
            n = 6'h3F;
            #1;

            check_outputs(6'h3F);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: control=1 (NOT), m=all ones", test_num);
            control = 1'b1;
            m = 6'h3F;
            n = 6'h00;
            #1;

            check_outputs(6'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: control=1 (NOT), m=alternate", test_num);
            control = 1'b1;
            m = 6'b101010;
            n = 6'b111111;
            #1;

            check_outputs(6'b010101);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: control=1 (NOT), m=random pattern", test_num);
            control = 1'b1;
            m = 6'b110011;
            n = 6'b000000;
            #1;

            check_outputs(6'b001100);
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
        input [5:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
