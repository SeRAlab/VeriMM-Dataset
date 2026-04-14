`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] i;
    wire [2:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i(i),
        .y(y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: No input bits set (All zeros)", test_num);
        i = 7'b000_0000;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Highest bit (i[6]) set only", test_num);
        i = 7'b100_0000;
        #1;

        check_outputs(3'd6);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Walking one from i[5] to i[1]", test_num);

        i = 7'b010_0000; #1;
 check_outputs(3'd5);
        i = 7'b001_0000; #1;
 check_outputs(3'd4);
        i = 7'b000_1000; #1;
 check_outputs(3'd3);
        i = 7'b000_0100; #1;
 check_outputs(3'd2);
        i = 7'b000_0010; #1;
 check_outputs(3'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Lowest bit (i[0]) set only", test_num);
        i = 7'b000_0001;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple bits set - MSB priority (i[6] is high)", test_num);
        i = 7'b111_1111;
        #1;

        check_outputs(3'd6);

        i = 7'b100_1001;
        #1;

        check_outputs(3'd6);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple bits set - Middle priority", test_num);
        i = 7'b001_1010;
        #1;

        check_outputs(3'd4);

        i = 7'b000_1011;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Overlapping bit patterns", test_num);
        i = 7'b011_0000;
        #1;

        check_outputs(3'd5);

        i = 7'b000_0011;
        #1;

        check_outputs(3'd1);
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
        input [2:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
