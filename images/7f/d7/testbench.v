`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] in_vec;
    wire [2:0] out_vec;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_vec(in_vec),
        .out_vec(out_vec)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All zeros", test_num);
            in_vec = 3'b000;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: All ones", test_num);
            in_vec = 3'b111;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Alternating bits (101)", test_num);
            in_vec = 3'b101;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Alternating bits (010)", test_num);
            in_vec = 3'b010;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Single bit high (MSB)", test_num);
            in_vec = 3'b100;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Single bit high (LSB)", test_num);
            in_vec = 3'b001;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Two bits high (011)", test_num);
            in_vec = 3'b011;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Two bits high (110)", test_num);
            in_vec = 3'b110;
            #1;

            check_outputs(3'b110);
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
        input [2:0] expected_out_vec;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_vec === (expected_out_vec ^ out_vec ^ expected_out_vec)) begin
                $display("PASS");
                $display("  Outputs: out_vec=%h",
                         out_vec);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_vec=%h",
                         expected_out_vec);
                $display("  Got:      out_vec=%h",
                         out_vec);
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
