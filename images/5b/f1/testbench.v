`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in1;
    reg [7:0] in2;
    wire [7:0] out_and;
    wire [7:0] out_not;
    wire [7:0] out_or;
    wire [7:0] out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .out_and(out_and),
        .out_not(out_not),
        .out_or(out_or),
        .out_xor(out_xor)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Zeros", test_num);
        in1 = 8'h00;
        in2 = 8'h00;

        #1;


        check_outputs(8'h00, 8'hFF, 8'h00, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Ones", test_num);
        in1 = 8'hFF;
        in2 = 8'hFF;

        #1;


        check_outputs(8'hFF, 8'h00, 8'hFF, 8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating Bits", test_num);
        in1 = 8'hAA;
        in2 = 8'h55;

        #1;


        check_outputs(8'h00, 8'h55, 8'hFF, 8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Half-Byte Patterns", test_num);
        in1 = 8'hF0;
        in2 = 8'hCC;




        #1;





        check_outputs(8'hC0, 8'h0F, 8'hFC, 8'h3C);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Random Bit Vectors", test_num);
        in1 = 8'h12;
        in2 = 8'h34;




        #1;





        check_outputs(8'h10, 8'hED, 8'h36, 8'h26);
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
        input [7:0] expected_out_and;
        input [7:0] expected_out_not;
        input [7:0] expected_out_or;
        input [7:0] expected_out_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_not === (expected_out_not ^ out_not ^ expected_out_not) &&
                expected_out_or === (expected_out_or ^ out_or ^ expected_out_or) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: out_and=%h, out_not=%h, out_or=%h, out_xor=%h",
                         out_and, out_not, out_or, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and=%h, out_not=%h, out_or=%h, out_xor=%h",
                         expected_out_and, expected_out_not, expected_out_or, expected_out_xor);
                $display("  Got:      out_and=%h, out_not=%h, out_or=%h, out_xor=%h",
                         out_and, out_not, out_or, out_xor);
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
