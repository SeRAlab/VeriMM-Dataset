`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in1;
    reg [15:0] in2;
    wire [31:0] out1;
    wire [31:0] out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .out1(out1),
        .out2(out2)
    );
    task testcase001;

        begin
            test_num = 1;
            in1 = 16'h0000;
            in2 = 16'h0000;
            $display("Test %0d: All Zeros", test_num);
            #1;

            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in1 = 16'hFFFF;
            in2 = 16'hFFFF;
            $display("Test %0d: All Ones", test_num);
            #1;

            check_outputs(32'h0000FFFF, 32'h0000FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in1 = 16'hAAAA;
            in2 = 16'h5555;
            $display("Test %0d: Alternating Complementary Bits", test_num);

            #1;


            check_outputs(32'h00000000, 32'h0000FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in1 = 16'hF0F0;
            in2 = 16'hFF00;
            $display("Test %0d: Overlapping Nibbles", test_num);


            #1;



            check_outputs(32'h0000F000, 32'h0000FF00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in1 = 16'h1234;
            in2 = 16'h4321;
            $display("Test %0d: Mixed Bit Patterns", test_num);


            #1;



            check_outputs(32'h00000220, 32'h00005335);
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
        input [31:0] expected_out1;
        input [31:0] expected_out2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2)) begin
                $display("PASS");
                $display("  Outputs: out1=%h, out2=%h",
                         out1, out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h, out2=%h",
                         expected_out1, expected_out2);
                $display("  Got:      out1=%h, out2=%h",
                         out1, out2);
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
