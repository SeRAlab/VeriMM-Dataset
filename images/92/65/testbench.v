`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] func;
    reg [31:0] in1;
    reg [31:0] in2;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .func(func),
        .in1(in1),
        .in2(in2),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Match func (001000) - Expect out = in2", test_num);
            func = 6'b001000;
            in1  = 32'hAAAAAAAA;
            in2  = 32'h55555555;
            #1;

            check_outputs(in2);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: func = 0 - Expect out = in1", test_num);
            func = 6'b000000;
            in1  = 32'h12345678;
            in2  = 32'h87654321;
            #1;

            check_outputs(in1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: func = 63 - Expect out = in1", test_num);
            func = 6'b111111;
            in1  = 32'hFFFFFFFF;
            in2  = 32'h00000000;
            #1;

            check_outputs(in1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: func = 7 (Boundary) - Expect out = in1", test_num);
            func = 6'b000111;
            in1  = 32'hDEADBEEF;
            in2  = 32'hCAFEBABE;
            #1;

            check_outputs(in1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: func = 9 (Boundary) - Expect out = in1", test_num);
            func = 6'b001001;
            in1  = 32'hFEEDFACE;
            in2  = 32'hBADC0DE1;
            #1;

            check_outputs(in1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Match func with zero/ones - Expect out = in2", test_num);
            func = 6'b001000;
            in1  = 32'h00000000;
            in2  = 32'hFFFFFFFF;
            #1;

            check_outputs(in2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random non-match - Expect out = in1", test_num);
            func = 6'b101010;
            in1  = 32'hAAAA5555;
            in2  = 32'h5555AAAA;
            #1;

            check_outputs(in1);
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
