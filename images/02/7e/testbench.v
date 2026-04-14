`timescale 1ns/1ps

module dynamic_range_compressor_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in_data;
    wire [3:0] out_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dynamic_range_compressor dut (
        .in_data(in_data),
        .out_data(out_data)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Zero Input", test_num);
        in_data = 4'sb0000;
        #1;

        check_outputs(4'sb0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Positive value within threshold", test_num);
        in_data = 4'sb0010;
        #1;

        check_outputs(4'sb0010);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Positive value above threshold", test_num);
        in_data = 4'sb0100;

        #1;


        check_outputs(4'sb0101);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Negative value within threshold", test_num);
        in_data = 4'sb1111;
        #1;

        check_outputs(4'sb1111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Negative value below threshold", test_num);
        in_data = 4'sb1101;

        #1;


        check_outputs(4'sb1100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Positive maximum value", test_num);
        in_data = 4'sb0111;
        #1;

        check_outputs(4'sb0111);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Negative maximum value", test_num);
        in_data = 4'sb1000;
        #1;

        check_outputs(4'sb1000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dynamic_range_compressor Testbench");
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
        input [3:0] expected_out_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data)) begin
                $display("PASS");
                $display("  Outputs: out_data=%h",
                         out_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%h",
                         expected_out_data);
                $display("  Got:      out_data=%h",
                         out_data);
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
