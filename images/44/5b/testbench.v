`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in_1;
    reg [3:0] in_2;
    wire [5:0] out_1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_1(in_1),
        .in_2(in_2),
        .out_1(out_1)
    );
    task testcase001;

    begin
        test_num = 1;
        in_1 = 4'b0000;
        in_2 = 4'b0000;

        #1;


        check_outputs(6'b000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in_1 = 4'b1111;
        in_2 = 4'b1111;

        #1;


        check_outputs(6'b111111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in_1 = 4'b0000;
        in_2 = 4'b1100;

        #1;


        check_outputs(6'b110000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in_1 = 4'b0011;
        in_2 = 4'b0000;

        #1;


        check_outputs(6'b000011);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in_1 = 4'b0010;
        in_2 = 4'b0001;

        #1;


        check_outputs(6'b001010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in_1 = 4'b0100;
        in_2 = 4'b0010;

        #1;


        check_outputs(6'b000100);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in_1 = 4'b1010;
        in_2 = 4'b0101;





        #1;






        check_outputs(6'b011010);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in_1 = 4'b0101;
        in_2 = 4'b1010;





        #1;






        check_outputs(6'b100101);
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
        input [5:0] expected_out_1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_1 === (expected_out_1 ^ out_1 ^ expected_out_1)) begin
                $display("PASS");
                $display("  Outputs: out_1=%h",
                         out_1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_1=%h",
                         expected_out_1);
                $display("  Got:      out_1=%h",
                         out_1);
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
