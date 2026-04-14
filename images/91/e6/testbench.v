`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] vec1;
    reg [3:0] vec2;
    wire o0;
    wire o1;
    wire o2;
    wire o3;
    wire o4;
    wire [3:0] out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .vec1(vec1),
        .vec2(vec2),
        .o0(o0),
        .o1(o1),
        .o2(o2),
        .o3(o3),
        .o4(o4),
        .out_xor(out_xor)
    );
    task testcase001;

        begin
            test_num = 1;
            vec1 = 4'b0000;
            vec2 = 4'b0000;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            vec1 = 4'b1111;
            vec2 = 4'b1111;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 4'b0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            vec1 = 4'b1010;
            vec2 = 4'b0101;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 4'b1111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            vec1 = 4'b1100;
            vec2 = 4'b1010;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 4'b0110);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            vec1 = 4'b0111;
            vec2 = 4'b0111;


            #1;



            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            vec1 = 4'b1000;
            vec2 = 4'b1000;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            vec1 = 4'b0001;
            vec2 = 4'b0001;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 4'b0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            vec1 = 4'b1000;
            vec2 = 4'b0000;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 4'b1000);
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
        input expected_o0;
        input expected_o1;
        input expected_o2;
        input expected_o3;
        input expected_o4;
        input [3:0] expected_out_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o0 === (expected_o0 ^ o0 ^ expected_o0) &&
                expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2) &&
                expected_o3 === (expected_o3 ^ o3 ^ expected_o3) &&
                expected_o4 === (expected_o4 ^ o4 ^ expected_o4) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: o0=%b, o1=%b, o2=%b, o3=%b, o4=%b, out_xor=%h",
                         o0, o1, o2, o3, o4, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o0=%b, o1=%b, o2=%b, o3=%b, o4=%b, out_xor=%h",
                         expected_o0, expected_o1, expected_o2, expected_o3, expected_o4, expected_out_xor);
                $display("  Got:      o0=%b, o1=%b, o2=%b, o3=%b, o4=%b, out_xor=%h",
                         o0, o1, o2, o3, o4, out_xor);
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
