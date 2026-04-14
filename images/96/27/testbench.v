`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [13:0] n;
    wire [12:0] out_and2;
    wire [12:0] out_nor2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .n(n),
        .out_and2(out_and2),
        .out_nor2(out_nor2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            n = 14'b00_0000_0000_0000;


            #1;



            check_outputs(13'h0000, 13'h1FFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones", test_num);
            n = 14'b11_1111_1111_1111;


            #1;



            check_outputs(13'h1FFF, 13'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating 1010", test_num);
            n = 14'b10_1010_1010_1010;



            #1;




            check_outputs(13'h0000, 13'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating 0101", test_num);
            n = 14'b01_0101_0101_0101;



            #1;




            check_outputs(13'h0000, 13'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Doublets 11001100", test_num);
            n = 14'b11_0011_0011_0011;







            #1;








            check_outputs(13'h1111, 13'h0444);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single 1 at LSB", test_num);
            n = 14'h0001;





            #1;






            check_outputs(13'h0000, 13'h1FFE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sliding Window 111 at LSB", test_num);
            n = 14'b00_0000_0000_0111;







            #1;








            check_outputs(13'h0003, 13'h1FF8);
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
        input [12:0] expected_out_and2;
        input [12:0] expected_out_nor2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_and2 === (expected_out_and2 ^ out_and2 ^ expected_out_and2) &&
                expected_out_nor2 === (expected_out_nor2 ^ out_nor2 ^ expected_out_nor2)) begin
                $display("PASS");
                $display("  Outputs: out_and2=%h, out_nor2=%h",
                         out_and2, out_nor2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and2=%h, out_nor2=%h",
                         expected_out_and2, expected_out_nor2);
                $display("  Got:      out_and2=%h, out_nor2=%h",
                         out_and2, out_nor2);
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
