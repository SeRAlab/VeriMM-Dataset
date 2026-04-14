`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] m;
    wire [8:0] out_or2;
    wire [8:0] out_xor2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .m(m),
        .out_or2(out_or2),
        .out_xor2(out_xor2)
    );
    task testcase001;

        begin
            test_num = 1;
            m = 10'b00_0000_0000;
            $display("Test %0d: All Zeros (m=%b)", test_num, m);
            #1;

            check_outputs(9'h000, 9'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            m = 10'b11_1111_1111;
            $display("Test %0d: All Ones (m=%b)", test_num, m);

            #1;


            check_outputs(9'h1FF, 9'h000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            m = 10'b10_1010_1010;
            $display("Test %0d: Alternating 1010... (m=%b)", test_num, m);

            #1;


            check_outputs(9'h1FF, 9'h1FF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            m = 10'b01_0101_0101;
            $display("Test %0d: Alternating 0101... (m=%b)", test_num, m);

            #1;


            check_outputs(9'h1FF, 9'h1FF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            m = 10'b00_0000_1100;
            $display("Test %0d: Double One (m=%b)", test_num, m);






            #1;







            check_outputs(9'h00E, 9'h00A);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            m = 10'b10_0000_0000;
            $display("Test %0d: MSB bit only (m=%b)", test_num, m);

            #1;


            check_outputs(9'h100, 9'h100);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            m = 10'b00_0000_0001;
            $display("Test %0d: LSB bit only (m=%b)", test_num, m);

            #1;


            check_outputs(9'h001, 9'h001);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            m = 10'b11_0011_0011;
            $display("Test %0d: Mixed block pattern (m=%b)", test_num, m);





            #1;






            check_outputs(9'h1B7, 9'h0AA);
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
        input [8:0] expected_out_or2;
        input [8:0] expected_out_xor2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_or2 === (expected_out_or2 ^ out_or2 ^ expected_out_or2) &&
                expected_out_xor2 === (expected_out_xor2 ^ out_xor2 ^ expected_out_xor2)) begin
                $display("PASS");
                $display("  Outputs: out_or2=%h, out_xor2=%h",
                         out_or2, out_xor2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_or2=%h, out_xor2=%h",
                         expected_out_or2, expected_out_xor2);
                $display("  Got:      out_or2=%h, out_xor2=%h",
                         out_or2, out_xor2);
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
