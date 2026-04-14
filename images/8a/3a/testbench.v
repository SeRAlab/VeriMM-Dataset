`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] sel;
    reg [3:0] w0;
    reg [3:0] w1;
    reg [3:0] w2;
    reg [3:0] w3;
    wire [3:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sel(sel),
        .w0(w0),
        .w1(w1),
        .w2(w2),
        .w3(w3),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select w0 (sel=00)", test_num);
            w0 = 4'b1010;
            w1 = 4'b0101;
            w2 = 4'b1111;
            w3 = 4'b0000;
            sel = 2'b00;
            #10;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select w1 (sel=01)", test_num);
            w0 = 4'b1010;
            w1 = 4'b0101;
            w2 = 4'b1111;
            w3 = 4'b0000;
            sel = 2'b01;
            #10;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Select w2 (sel=10)", test_num);
            w0 = 4'b1010;
            w1 = 4'b0101;
            w2 = 4'b1111;
            w3 = 4'b0000;
            sel = 2'b10;
            #10;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Select w3 (sel=11)", test_num);
            w0 = 4'b1010;
            w1 = 4'b0101;
            w2 = 4'b1111;
            w3 = 4'b0000;
            sel = 2'b11;
            #10;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Boundary values (All ones)", test_num);
            w0 = 4'hF;
            w1 = 4'hE;
            w2 = 4'hD;
            w3 = 4'hC;
            sel = 2'b00;
            #10;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Changing data on active selection", test_num);
            w0 = 4'h0;
            w1 = 4'h0;
            w2 = 4'h7;
            w3 = 4'h0;
            sel = 2'b10;
            #5;
            w2 = 4'hB;
            #5;
            #1;

            check_outputs(4'hB);
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
        input [3:0] expected_y;
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
