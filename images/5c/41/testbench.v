`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data;
    reg p1;
    reg p2;
    wire [3:0] out_x;
    wire [3:0] out_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .p1(p1),
        .p2(p2),
        .out_x(out_x),
        .out_y(out_y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: p1=0, p2=0 (Lower Half, Lower Range)", test_num);
            data = 32'h87654321;
            p1 = 1'b0;
            p2 = 1'b0;

            #1;


            check_outputs(4'h1, 4'h3);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: p1=0, p2=1 (Lower Half, Higher Range)", test_num);
            data = 32'h87654321;
            p1 = 1'b0;
            p2 = 1'b1;

            #1;


            check_outputs(4'h2, 4'h4);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: p1=1, p2=0 (Upper Half, Lower Range)", test_num);
            data = 32'h87654321;
            p1 = 1'b1;
            p2 = 1'b0;

            #1;


            check_outputs(4'h5, 4'h7);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: p1=1, p2=1 (Upper Half, Higher Range)", test_num);
            data = 32'h87654321;
            p1 = 1'b1;
            p2 = 1'b1;

            #1;


            check_outputs(4'h6, 4'h8);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: All Zeros Data", test_num);
            data = 32'h00000000;
            p1 = 1'b1;
            p2 = 1'b1;
            #1;

            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: All Ones Data", test_num);
            data = 32'hFFFFFFFF;
            p1 = 1'b0;
            p2 = 1'b1;
            #1;

            check_outputs(4'hF, 4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Alternating Pattern 1 (0xA...)", test_num);
            data = 32'hAAAAAAAA;
            p1 = 1'b0;
            p2 = 1'b0;
            #1;

            check_outputs(4'hA, 4'hA);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Alternating Pattern 2 (0x5...)", test_num);
            data = 32'h55555555;
            p1 = 1'b1;
            p2 = 1'b1;
            #1;

            check_outputs(4'h5, 4'h5);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Mixed High/Low Data", test_num);
            data = 32'hABCDEF01;
            p1 = 1'b1;
            p2 = 1'b0;




            #1;





            check_outputs(4'hD, 4'hB);
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
        input [3:0] expected_out_x;
        input [3:0] expected_out_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_x === (expected_out_x ^ out_x ^ expected_out_x) &&
                expected_out_y === (expected_out_y ^ out_y ^ expected_out_y)) begin
                $display("PASS");
                $display("  Outputs: out_x=%h, out_y=%h",
                         out_x, out_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_x=%h, out_y=%h",
                         expected_out_x, expected_out_y);
                $display("  Got:      out_x=%h, out_y=%h",
                         out_x, out_y);
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
