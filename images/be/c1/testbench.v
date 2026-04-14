`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    reg enable;
    reg [1:0] select;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .enable(enable),
        .select(select),
        .data_out(data_out)
    );
    task reset_to_zero;

    begin
        enable = 1;
        data_in = 4'b0000;
        select = 2'b00;
        #5;
    end
        endtask

    task testcase001;

    begin
        reset_to_zero();
        test_num = test_num + 1;
        $display("Test Case %0d: Select data_in[0]", test_num);
        data_in = 4'b0001;
        select = 2'b00;
        enable = 1;
        #10;
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase002;

    begin
        reset_to_zero();
        test_num = test_num + 1;
        $display("Test Case %0d: Select data_in[1]", test_num);
        data_in = 4'b0010;
        select = 2'b01;
        enable = 1;
        #10;
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase003;

    begin
        reset_to_zero();
        test_num = test_num + 1;
        $display("Test Case %0d: Select data_in[2]", test_num);
        data_in = 4'b0100;
        select = 2'b10;
        enable = 1;
        #10;
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase004;

    begin
        reset_to_zero();
        test_num = test_num + 1;
        $display("Test Case %0d: Select data_in[3]", test_num);
        data_in = 4'b1000;
        select = 2'b11;
        enable = 1;
        #10;
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase005;

    begin
        reset_to_zero();
        test_num = test_num + 1;
        $display("Test Case %0d: Select a bit with value 0", test_num);
        data_in = 4'b1110;
        select = 2'b00;
        enable = 1;
        #10;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase006;

    begin
        reset_to_zero();
        test_num = test_num + 1;
        $display("Test Case %0d: Latch retention on enable 1->0", test_num);

        data_in = 4'b0001; select = 2'b00; enable = 1;
        #10;

        enable = 0;
        #5;

        data_in = 4'b1110;
        select = 2'b11;
        #10;
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase007;

    begin
        reset_to_zero();
        test_num = test_num + 1;
        $display("Test Case %0d: Transparent tracking when enable is high", test_num);
        enable = 1;
        data_in = 4'b0001; select = 2'b00;
        #5;
        data_in = 4'b0000;
        #10;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase008;

    begin
        reset_to_zero();
        test_num = test_num + 1;
        $display("Test Case %0d: Retention after multiple input changes", test_num);
        data_in = 4'b1000; select = 2'b11; enable = 1; #5;
        enable = 0; #5;
        data_in = 4'b0100; select = 2'b10; #5;
        data_in = 4'b1111; select = 2'b01; #10;
        #1;

        check_outputs(4'h1);
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
        input [3:0] expected_data_out;
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
