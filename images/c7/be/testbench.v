`timescale 1ns/1ps

module concat_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] i0;
    reg [5:0] i1;
    wire [7:0] o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    concat_module dut (
        .i0(i0),
        .i1(i1),
        .o(o)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All zeros", test_num);
            i1 = 6'b000000;
            i0 = 2'b00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: All ones", test_num);
            i1 = 6'b111111;
            i0 = 2'b11;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: i1 max, i0 min", test_num);
            i1 = 6'b111111;
            i0 = 2'b00;
            #1;

            check_outputs(8'hFC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: i1 min, i0 max", test_num);
            i1 = 6'b000000;
            i0 = 2'b11;
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Alternating pattern AA", test_num);
            i1 = 6'b101010;
            i0 = 2'b10;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Alternating pattern 55", test_num);
            i1 = 6'b010101;
            i0 = 2'b01;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Random pattern CD", test_num);
            i1 = 6'h33;
            i0 = 2'h1;
            #1;

            check_outputs(8'hCD);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Boundary check (i1=1, i0=2)", test_num);
            i1 = 6'd1;
            i0 = 2'd2;
            #1;

            check_outputs(8'h06);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("concat_module Testbench");
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
        input [7:0] expected_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%h",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%h",
                         expected_o);
                $display("  Got:      o=%h",
                         o);
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
