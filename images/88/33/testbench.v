`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in_vec;
    wire [31:0] out_vec;

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
            test_num = test_num + 1;
            $display("Test %0d: Simple Incrementing Bytes", test_num);
            in_vec = 32'h01020304;
            #1;

            check_outputs(32'h04030201);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Standard Hex Pattern", test_num);
            in_vec = 32'h12345678;
            #1;

            check_outputs(32'h78563412);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Common Magic Number", test_num);
            in_vec = 32'hDEADBEEF;
            #1;

            check_outputs(32'hEFBEADDE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Byte Active (LSB to MSB)", test_num);
            in_vec = 32'h000000FF;
            #1;

            check_outputs(32'hFF000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Byte Active (MSB to LSB)", test_num);
            in_vec = 32'hAA000000;
            #1;

            check_outputs(32'h000000AA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Ones", test_num);
            in_vec = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bits and Bytes", test_num);
            in_vec = 32'h55AA00FF;
            #1;

            check_outputs(32'hFF00AA55);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros", test_num);
            in_vec = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
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
        input [31:0] expected_out_vec;
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
