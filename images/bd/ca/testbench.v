`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [191:0] in;
    wire [8:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All segments zero", test_num);
        in = 192'h0;
        #1;

        check_outputs(9'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All segments maximum (3'b111)", test_num);
        in = {64{3'b111}};

        #1;


        check_outputs(9'd448);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Each segment set to 1", test_num);
        in = {64{3'b001}};

        #1;


        check_outputs(9'd64);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating segments (7 and 0)", test_num);
        in = {32{3'b111, 3'b000}};

        #1;


        check_outputs(9'd224);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single segment active (First)", test_num);
        in = 192'h0;
        in[2:0] = 3'd5;
        #1;

        check_outputs(9'd5);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single segment active (Last)", test_num);
        in = 192'h0;
        in[191:189] = 3'd6;
        #1;

        check_outputs(9'd6);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pattern sum (1, 2, 3, 4)", test_num);
        in = {16{3'b100, 3'b011, 3'b010, 3'b001}};

        #1;


        check_outputs(9'd160);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Power of 2 sum", test_num);
        in = {64{3'b100}};

        #1;


        check_outputs(9'd256);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Prime-like pattern", test_num);
        in = {21{3'b101, 3'b011, 3'b001}};
        in[191:189] = 3'b010;

        #1;


        check_outputs(9'd191);
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
        input [8:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
