`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ce;
    reg clk;
    reg clr;
    wire [31:0] op;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .clk(clk),
        .clr(clr),
        .op(op)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Baseline verification - all inputs zero", test_num);

        clk = 0;
        ce = 0;
        clr = 0;
        #10;

        #1;


        check_outputs(32'h1FF00000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Verifying invariance under clock transitions", test_num);

        clk = 0; ce = 0; clr = 0;
        #10;

        repeat(10) begin
            #5 clk = ~clk;
        end

        #1;


        check_outputs(32'h1FF00000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Verifying invariance with Enable (ce) high", test_num);

        clk = 0; ce = 0; clr = 0;
        #10;

        ce = 1;
        #10 clk = 1;
        #10 clk = 0;

        #1;


        check_outputs(32'h1FF00000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Verifying invariance with Clear (clr) high", test_num);

        clk = 0; ce = 0; clr = 0;
        #10;

        clr = 1;
        #10 clk = 1;
        #10 clk = 0;

        #1;


        check_outputs(32'h1FF00000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Verifying invariance with all control signals active", test_num);

        clk = 0; ce = 0; clr = 0;
        #10;

        ce = 1;
        clr = 1;
        repeat(4) begin
            #5 clk = ~clk;
        end

        #1;


        check_outputs(32'h1FF00000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Rapid signal switching", test_num);

        clk = 0; ce = 0; clr = 0;
        #10;

        ce = 1; clr = 0; #2;
        ce = 0; clr = 1; #2;
        ce = 1; clr = 1; #2;
        clk = 1; #2;
        clr = 0; #2;

        #1;


        check_outputs(32'h1FF00000);
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
        input [31:0] expected_op;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_op === (expected_op ^ op ^ expected_op)) begin
                $display("PASS");
                $display("  Outputs: op=%h",
                         op);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: op=%h",
                         expected_op);
                $display("  Got:      op=%h",
                         op);
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
