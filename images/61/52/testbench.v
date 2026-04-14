`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] in;
    wire [3:0] out;
    wire [3:0] out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out(out),
        .out2(out2)
    );
    task testcase001;

        begin
            test_num = 1;

            in = 10'b00_0000_0000;
            #10;
            $display("Test %0d: All bits zero", test_num);
            #1;

            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;

            in = 10'b00_1111_1111;
            #10;
            $display("Test %0d: Slices set to all ones", test_num);
            #1;

            check_outputs(4'hF, 4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;

            in = 10'b00_1010_0101;
            #10;
            $display("Test %0d: Alternating bit patterns (0xA5)", test_num);
            #1;

            check_outputs(4'h5, 4'hA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;

            in = 10'b11_0001_0010;
            #10;
            $display("Test %0d: Distinct slice values with upper bits set", test_num);
            #1;

            check_outputs(4'h2, 4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;

            in = 10'b00_1110_0111;
            #10;
            $display("Test %0d: Checking bit boundaries", test_num);
            #1;

            check_outputs(4'h7, 4'hE);
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
        input [3:0] expected_out;
        input [3:0] expected_out2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2)) begin
                $display("PASS");
                $display("  Outputs: out=%h, out2=%h",
                         out, out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, out2=%h",
                         expected_out, expected_out2);
                $display("  Got:      out=%h, out2=%h",
                         out, out2);
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
