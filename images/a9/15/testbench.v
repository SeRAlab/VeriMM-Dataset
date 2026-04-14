`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] input_vector;
    wire [7:0] output_vector;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_vector(input_vector),
        .output_vector(output_vector)
    );
    task testcase001;

    begin
        test_num = 1;
        input_vector = 8'b00000000;
        #1;

        check_outputs(8'b00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        input_vector = 8'b11111111;
        #1;

        check_outputs(8'b11111111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        input_vector = 8'b10101010;

        #1;


        check_outputs(8'b01010101);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        input_vector = 8'b01010101;

        #1;


        check_outputs(8'b10101010);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        input_vector = 8'b11001100;

        #1;


        check_outputs(8'b11001100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        input_vector = 8'b00000001;
        #1;

        check_outputs(8'b00000010);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        input_vector = 8'b01000000;
        #1;

        check_outputs(8'b10000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        input_vector = 8'b11100001;





        #1;






        check_outputs(8'b11010010);
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
        input [7:0] expected_output_vector;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_vector === (expected_output_vector ^ output_vector ^ expected_output_vector)) begin
                $display("PASS");
                $display("  Outputs: output_vector=%h",
                         output_vector);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_vector=%h",
                         expected_output_vector);
                $display("  Got:      output_vector=%h",
                         output_vector);
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
