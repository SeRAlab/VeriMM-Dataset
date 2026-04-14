`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in0;
    reg [7:0] in1;
    reg sel;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .sel(sel),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select in0 (Basic check)", test_num);
        sel = 1'b0;
        in0 = 8'hA5;
        in1 = 8'h5A;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select in1 (Basic check)", test_num);
        sel = 1'b1;
        in0 = 8'hA5;
        in1 = 8'h5A;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select in0 (All Zeros)", test_num);
        sel = 1'b0;
        in0 = 8'h00;
        in1 = 8'hFF;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select in1 (All Ones)", test_num);
        sel = 1'b1;
        in0 = 8'h00;
        in1 = 8'hFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Toggle Select with fixed inputs", test_num);
        in0 = 8'h12;
        in1 = 8'h34;
        sel = 1'b0;
        #5;
        sel = 1'b1;
        #1;

        check_outputs(8'h34);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Change in0 while selected", test_num);
        sel = 1'b0;
        in1 = 8'h00;
        in0 = 8'hAA;
        #5;
        in0 = 8'hBB;
        #1;

        check_outputs(8'hBB);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Change in1 while selected", test_num);
        sel = 1'b1;
        in0 = 8'h00;
        in1 = 8'hCC;
        #5;
        in1 = 8'hDD;
        #1;

        check_outputs(8'hDD);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary values (8'h7F vs 8'h80)", test_num);
        sel = 1'b0;
        in0 = 8'h7F;
        in1 = 8'h80;
        #1;

        check_outputs(8'h7F);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select in1 with boundary values", test_num);
        sel = 1'b1;
        in0 = 8'h7F;
        in1 = 8'h80;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Walking bit test", test_num);
        sel = 1'b0;
        in1 = 8'h00;
        in0 = 8'b00000001;
        #2; in0 = 8'b00000010;
        #2; in0 = 8'b00000100;
        #2; in0 = 8'b00001000;
        #2; in0 = 8'b00010000;
        #2; in0 = 8'b00100000;
        #2; in0 = 8'b01000000;
        #2; in0 = 8'b10000000;
        #1;

        check_outputs(8'b10000000);
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
