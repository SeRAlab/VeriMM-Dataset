`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ctrl;
    reg [7:0] data_in1;
    reg [7:0] data_in2;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .data_in1(data_in1),
        .data_in2(data_in2),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Basic Addition (ctrl=0)", test_num);
        ctrl = 0;
        data_in1 = 8'h05;
        data_in2 = 8'h0A;

        #1;


        check_outputs(8'h0F);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition with Negation (ctrl=1)", test_num);
        ctrl = 1;
        data_in1 = 8'h05;
        data_in2 = 8'h0A;

        #1;


        check_outputs(8'hF0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero Result (ctrl=0)", test_num);
        ctrl = 0;
        data_in1 = 8'h00;
        data_in2 = 8'h00;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero Result Negated (ctrl=1)", test_num);
        ctrl = 1;
        data_in1 = 8'h00;
        data_in2 = 8'h00;

        #1;


        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Overflow Truncation (ctrl=0)", test_num);
        ctrl = 0;
        data_in1 = 8'hFF;
        data_in2 = 8'h01;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Overflow Truncation Negated (ctrl=1)", test_num);
        ctrl = 1;
        data_in1 = 8'hFF;
        data_in2 = 8'h01;

        #1;


        check_outputs(8'hFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max Sum 0xFF (ctrl=0)", test_num);
        ctrl = 0;
        data_in1 = 8'hAA;
        data_in2 = 8'h55;

        #1;


        check_outputs(8'hFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max Sum 0xFF Negated (ctrl=1)", test_num);
        ctrl = 1;
        data_in1 = 8'hAA;
        data_in2 = 8'h55;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Arbitrary Addition (ctrl=0)", test_num);
        ctrl = 0;
        data_in1 = 8'h12;
        data_in2 = 8'h34;

        #1;


        check_outputs(8'h46);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary Values (ctrl=1)", test_num);
        ctrl = 1;
        data_in1 = 8'h80;
        data_in2 = 8'h7F;

        #1;


        check_outputs(8'h00);
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
        testcase009();
        testcase010();
        
        
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
        input [7:0] expected_data_out;
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
