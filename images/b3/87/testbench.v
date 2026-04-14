`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire eq;
    wire [1:0] ge;
    wire [1:0] gt;
    wire [1:0] le;
    wire [1:0] lt;
    wire [1:0] ne;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .eq(eq),
        .ge(ge),
        .gt(gt),
        .le(le),
        .lt(lt),
        .ne(ne)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        a = 4'b0000; b = 4'b0000;
        $display("Testcase %0d: Equality test (Zeroes) - a=0, b=0", test_num);

        #1;


        check_outputs(1'b1, 2'b11, 2'b00, 2'b11, 2'b00, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        a = 4'b0111; b = 4'b0010;
        $display("Testcase %0d: Positive GT test - a=7, b=2", test_num);


        #1;



        check_outputs(1'b0, 2'b11, 2'b11, 2'b00, 2'b00, 2'b11);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        a = 4'b0001; b = 4'b0100;
        $display("Testcase %0d: Positive LT test - a=1, b=4", test_num);


        #1;



        check_outputs(1'b0, 2'b00, 2'b00, 2'b11, 2'b11, 2'b11);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        a = 4'b1111; b = 4'b0001;
        $display("Testcase %0d: Mixed Sign GT/LT - a=4'b1111, b=4'b0001", test_num);





        #1;






        check_outputs(1'b0, 2'b01, 2'b01, 2'b10, 2'b10, 2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        a = 4'b0010; b = 4'b1110;
        $display("Testcase %0d: Mixed Sign LT/GT - a=4'b0010, b=4'b1110", test_num);





        #1;






        check_outputs(1'b0, 2'b10, 2'b10, 2'b01, 2'b01, 2'b11);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        a = 4'b1000; b = 4'b1000;
        $display("Testcase %0d: Negative Equality - a=4'b1000, b=4'b1000", test_num);

        #1;


        check_outputs(1'b1, 2'b11, 2'b00, 2'b11, 2'b00, 2'b00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        a = 4'b1001; b = 4'b1100;
        $display("Testcase %0d: Both Negative LT - a=-7, b=-4", test_num);


        #1;



        check_outputs(1'b0, 2'b00, 2'b00, 2'b11, 2'b11, 2'b11);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        a = 4'b1110; b = 4'b1010;
        $display("Testcase %0d: Both Negative GT - a=-2, b=-6", test_num);


        #1;



        check_outputs(1'b0, 2'b11, 2'b11, 2'b00, 2'b00, 2'b11);
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
        input expected_eq;
        input [1:0] expected_ge;
        input [1:0] expected_gt;
        input [1:0] expected_le;
        input [1:0] expected_lt;
        input [1:0] expected_ne;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eq === (expected_eq ^ eq ^ expected_eq) &&
                expected_ge === (expected_ge ^ ge ^ expected_ge) &&
                expected_gt === (expected_gt ^ gt ^ expected_gt) &&
                expected_le === (expected_le ^ le ^ expected_le) &&
                expected_lt === (expected_lt ^ lt ^ expected_lt) &&
                expected_ne === (expected_ne ^ ne ^ expected_ne)) begin
                $display("PASS");
                $display("  Outputs: eq=%b, ge=%h, gt=%h, le=%h, lt=%h, ne=%h",
                         eq, ge, gt, le, lt, ne);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eq=%b, ge=%h, gt=%h, le=%h, lt=%h, ne=%h",
                         expected_eq, expected_ge, expected_gt, expected_le, expected_lt, expected_ne);
                $display("  Got:      eq=%b, ge=%h, gt=%h, le=%h, lt=%h, ne=%h",
                         eq, ge, gt, le, lt, ne);
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
