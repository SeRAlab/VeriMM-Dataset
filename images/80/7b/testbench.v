`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg choose;
    reg [7:0] in1;
    reg [7:0] in2;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .choose(choose),
        .in1(in1),
        .in2(in2),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            in1 = 8'hAA;
            in2 = 8'h55;
            choose = 1'b0;
            $display("Testcase %0d: Select in1 (choose=0)", test_num);
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in1 = 8'hAA;
            in2 = 8'h55;
            choose = 1'b1;
            $display("Testcase %0d: Select in2 (choose=1)", test_num);
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in1 = 8'hFF;
            in2 = 8'h00;
            choose = 1'b0;
            $display("Testcase %0d: Select in1 (All 1s vs All 0s)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in1 = 8'hFF;
            in2 = 8'h00;
            choose = 1'b1;
            $display("Testcase %0d: Select in2 (All 1s vs All 0s)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in1 = 8'h12;
            in2 = 8'h34;
            choose = 1'b0;
            $display("Testcase %0d: Random pattern selection 1", test_num);
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in1 = 8'h12;
            in2 = 8'h34;
            choose = 1'b1;
            $display("Testcase %0d: Random pattern selection 2", test_num);
            #1;

            check_outputs(8'h34);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in1 = 8'h01;
            in2 = 8'h80;
            choose = 1'b0;
            $display("Testcase %0d: Boundary bit values", test_num);
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in1 = 8'h01;
            in2 = 8'h80;
            choose = 1'b1;
            $display("Testcase %0d: Boundary bit values", test_num);
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            in1 = 8'h5A;
            in2 = 8'hA5;

            choose = 1'bx;
            $display("Testcase %0d: Invalid selector (choose=X)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            in1 = 8'h5A;
            in2 = 8'hA5;

            choose = 1'bz;
            $display("Testcase %0d: Invalid selector (choose=Z)", test_num);
            #1;

            check_outputs(8'h00);
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
        testcase010();
        
        
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
        input [7:0] expected_out;
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
