`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg [3:0] c;
    wire q;
    wire [3:0] r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .c(c),
        .q(q),
        .r(r)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All zeros (c=0, a=0)", test_num);
        c = 4'b0000; a = 1'b0;
        #10;
        #1;

        check_outputs(1'b0, 4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Dividend bit high (c=0, a=1)", test_num);
        c = 4'b0000; a = 1'b1;
        #10;


        #1;



        check_outputs(1'b1, 4'b0001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Divisor Max (c=15, a=0)", test_num);
        c = 4'b1111; a = 1'b0;
        #10;
        #1;

        check_outputs(1'b0, 4'b0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All high (c=15, a=1)", test_num);
        c = 4'b1111; a = 1'b1;
        #10;
        #1;

        check_outputs(1'b0, 4'b0001);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pattern (c=10, a=1)", test_num);
        c = 4'b1010; a = 1'b1;
        #10;
        #1;

        check_outputs(1'b0, 4'b0001);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pattern (c=5, a=0)", test_num);
        c = 4'b0101; a = 1'b0;
        #10;
        #1;

        check_outputs(1'b0, 4'b0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mid-range (c=8, a=1)", test_num);
        c = 4'b1000; a = 1'b1;
        #10;
        #1;

        check_outputs(1'b0, 4'b0001);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bit Walk (c=3, a=1)", test_num);
        c = 4'b0011; a = 1'b1;
        #10;
        #1;

        check_outputs(1'b0, 4'b0001);
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
        input expected_q;
        input [3:0] expected_r;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_r === (expected_r ^ r ^ expected_r)) begin
                $display("PASS");
                $display("  Outputs: q=%b, r=%h",
                         q, r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, r=%h",
                         expected_q, expected_r);
                $display("  Got:      q=%b, r=%h",
                         q, r);
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
