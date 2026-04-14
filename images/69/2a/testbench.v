`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg s;
    reg [2:0] x;
    reg [2:0] y;
    wire [2:0] o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .s(s),
        .x(x),
        .y(y),
        .o(o)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select x (s=0), x=3'b000, y=3'b111", test_num);
            s = 0;
            x = 3'b000;
            y = 3'b111;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select y (s=1), x=3'b000, y=3'b111", test_num);
            s = 1;
            x = 3'b000;
            y = 3'b111;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Select x (s=0), x=3'b101, y=3'b010", test_num);
            s = 0;
            x = 3'b101;
            y = 3'b010;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Select y (s=1), x=3'b101, y=3'b010", test_num);
            s = 1;
            x = 3'b101;
            y = 3'b010;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Select x (s=0), x=3'b111, y=3'b000", test_num);
            s = 0;
            x = 3'b111;
            y = 3'b000;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Select y (s=1), x=3'b111, y=3'b110", test_num);
            s = 1;
            x = 3'b111;
            y = 3'b110;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Select x (s=0), x=3'b011, y=3'b100", test_num);
            s = 0;
            x = 3'b011;
            y = 3'b100;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Select y (s=1), x=3'b111, y=3'b101", test_num);
            s = 1;
            x = 3'b111;
            y = 3'b101;
            #1;

            check_outputs(3'b101);
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
        input [2:0] expected_o;
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
