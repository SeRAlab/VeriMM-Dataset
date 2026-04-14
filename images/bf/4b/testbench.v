`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] decode_vec;
    wire [7:0] data1;
    wire [7:0] data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .decode_vec(decode_vec),
        .data1(data1),
        .data2(data2)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input all low", test_num);
        decode_vec = 8'b0000_0000;
        #1;

        check_outputs(8'h00, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Second bit high (bit 1)", test_num);
        decode_vec = 8'b0000_0010;
        #1;

        check_outputs(8'h55, 8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Third bit high (bit 2)", test_num);
        decode_vec = 8'b0000_0100;
        #1;

        check_outputs(8'h00, 8'h55);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bits 1 and 2 high", test_num);
        decode_vec = 8'b0000_0110;
        #1;

        check_outputs(8'h55, 8'h55);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Target bits low, other bits high", test_num);
        decode_vec = 8'b1111_1001;
        #1;

        check_outputs(8'h00, 8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All bits high", test_num);
        decode_vec = 8'hFF;
        #1;

        check_outputs(8'h55, 8'h55);
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
        input [7:0] expected_data1;
        input [7:0] expected_data2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data1 === (expected_data1 ^ data1 ^ expected_data1) &&
                expected_data2 === (expected_data2 ^ data2 ^ expected_data2)) begin
                $display("PASS");
                $display("  Outputs: data1=%h, data2=%h",
                         data1, data2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data1=%h, data2=%h",
                         expected_data1, expected_data2);
                $display("  Got:      data1=%h, data2=%h",
                         data1, data2);
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
