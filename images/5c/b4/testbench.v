`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in0;
    reg [31:0] in1;
    wire done;
    wire [31:0] output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .done(done),
        .output(output)
    );
    task testcase001;

    begin
        test_num = 1;
        in0 = 32'h00000000;
        in1 = 32'h00000000;

        #1;


        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in0 = 32'd100;
        in1 = 32'd250;

        #1;


        check_outputs(1'b1, 32'd350);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in0 = 32'hFFFFFFFF;
        in1 = 32'h00000001;

        #1;


        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in0 = 32'h55555555;
        in1 = 32'hAAAAAAAA;

        #1;


        check_outputs(1'b1, 32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in0 = 32'h12345678;
        in1 = 32'h11111111;

        #1;


        check_outputs(1'b1, 32'h23456789);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in0 = 32'h7FFFFFFF;
        in1 = 32'h00000001;

        #1;


        check_outputs(1'b1, 32'h80000000);
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
        input expected_done;
        input [31:0] expected_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_output === (expected_output ^ output ^ expected_output)) begin
                $display("PASS");
                $display("  Outputs: done=%b, output=%h",
                         done, output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, output=%h",
                         expected_done, expected_output);
                $display("  Got:      done=%b, output=%h",
                         done, output);
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
