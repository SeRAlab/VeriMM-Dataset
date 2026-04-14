`timescale 1ns/1ps

module bitwise_operation_tb;

    // Testbench signals (combinational circuit)
    reg [21:0] input_vec;
    wire [20:0] output_and;
    wire [20:0] output_or;
    wire [21:0] output_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bitwise_operation dut (
        .input_vec(input_vec),
        .output_and(output_and),
        .output_or(output_or),
        .output_xor(output_xor)
    );
    task testcase001;

    begin
        input_vec = 22'h0;
        #1;

        check_outputs(21'h0, 21'h0, 22'h0);
    end
        endtask

    task testcase002;

    begin
        input_vec = 22'h3FFFFF;
        #1;

        check_outputs(21'h1FFFFF, 21'h1FFFFF, 22'h0);
    end
        endtask

    task testcase003;

    begin
        input_vec = 22'h1;



        #1;




        check_outputs(21'h0, 21'h1, 22'h200001);
    end
        endtask

    task testcase004;

    begin
        input_vec = 22'h200000;



        #1;




        check_outputs(21'h0, 21'h100000, 22'h300000);
    end
        endtask

    task testcase005;

    begin
        input_vec = 22'h3;



        #1;




        check_outputs(21'h1, 21'h3, 22'h200002);
    end
        endtask

    task testcase006;

    begin
        input_vec = 22'h2AAAAA;



        #1;




        check_outputs(21'h0, 21'h1FFFFF, 22'h3FFFFF);
    end
        endtask

    task testcase007;

    begin
        input_vec = 22'h155555;
        #1;

        check_outputs(21'h0, 21'h1FFFFF, 22'h3FFFFF);
    end
        endtask

    task testcase008;

    begin
        input_vec = 22'h100000;



        #1;




        check_outputs(21'h0, 21'h180000, 22'h180000);
    end
        endtask

    task testcase009;

    begin
        input_vec = 22'h200001;



        #1;




        check_outputs(21'h0, 21'h100001, 22'h100001);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bitwise_operation Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [20:0] expected_output_and;
        input [20:0] expected_output_or;
        input [21:0] expected_output_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_and === (expected_output_and ^ output_and ^ expected_output_and) &&
                expected_output_or === (expected_output_or ^ output_or ^ expected_output_or) &&
                expected_output_xor === (expected_output_xor ^ output_xor ^ expected_output_xor)) begin
                $display("PASS");
                $display("  Outputs: output_and=%h, output_or=%h, output_xor=%h",
                         output_and, output_or, output_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_and=%h, output_or=%h, output_xor=%h",
                         expected_output_and, expected_output_or, expected_output_xor);
                $display("  Got:      output_and=%h, output_or=%h, output_xor=%h",
                         output_and, output_or, output_xor);
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
