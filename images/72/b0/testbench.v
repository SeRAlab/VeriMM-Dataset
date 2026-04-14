`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] encode_in;
    wire [63:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .encode_in(encode_in),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: encode_in = 0", test_num);
        encode_in = 6'd0;
        #1;

        check_outputs(64'h0000_0000_0000_0001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: encode_in = 1", test_num);
        encode_in = 6'd1;
        #1;

        check_outputs(64'h0000_0000_0000_0002);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: encode_in = 8", test_num);
        encode_in = 6'd8;
        #1;

        check_outputs(64'h0000_0000_0000_0100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: encode_in = 15", test_num);
        encode_in = 6'd15;
        #1;

        check_outputs(64'h0000_0000_0000_8000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: encode_in = 31", test_num);
        encode_in = 6'd31;
        #1;

        check_outputs(64'h0000_0000_8000_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: encode_in = 32", test_num);
        encode_in = 6'd32;
        #1;

        check_outputs(64'h0000_0001_0000_0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: encode_in = 42", test_num);
        encode_in = 6'd42;

        #1;


        check_outputs(64'h0000_0400_0000_0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: encode_in = 63", test_num);
        encode_in = 6'd63;
        #1;

        check_outputs(64'h8000_0000_0000_0000);
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
        input [63:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
