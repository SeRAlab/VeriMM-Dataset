`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [49:0] input_vector;
    wire [49:0] output_vector;

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
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            input_vector = 50'h0;
            #1;

            check_outputs(50'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones", test_num);
            input_vector = 50'h3FFFFFFFFFFFF;
            #1;

            check_outputs(50'h3FFFFFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: LSB Wrap Around", test_num);


            input_vector = 50'h0000000000001;
            #1;

            check_outputs(50'h2000000000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: MSB Shift Right", test_num);

            input_vector = 50'h2000000000000;
            #1;

            check_outputs(50'h1000000000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Pattern 1", test_num);



            input_vector = 50'h1555555555555;
            #1;

            check_outputs(50'h2AAAAAAAAAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Pattern 2", test_num);



            input_vector = 50'h2AAAAAAAAAAAA;
            #1;

            check_outputs(50'h1555555555555);
        end
        endtask

    task testcase007;

        reg [49:0] pattern;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Walking One (Mid-vector)", test_num);
            pattern = 50'h0000040000000;
            input_vector = pattern;

            #1;


            check_outputs(50'h0000020000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random Hex Pattern", test_num);
            input_vector = 50'h3C3C3C3C3C3C3;



            #1;




            check_outputs({input_vector[0], input_vector[49:1]});
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
        input [49:0] expected_output_vector;
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
