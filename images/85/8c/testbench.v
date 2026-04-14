`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [31:0] initial_value;
    reg [31:0] modulus;
    reg reset;
    reg [31:0] time_delay;
    wire cout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .initial_value(initial_value),
        .modulus(modulus),
        .reset(reset),
        .time_delay(time_delay),
        .cout(cout)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic Mod 2, No Delay - Expect cout=1", test_num);
        initial_value = 32'd1;
        modulus = 32'd2;
        time_delay = 32'd0;
        reset = 1; #20; reset = 0;


        repeat(2) @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic Mod 2, No Delay - Expect cout=0 after 2 periods", test_num);
        initial_value = 32'd1;
        modulus = 32'd2;
        time_delay = 32'd0;
        reset = 1; #20; reset = 0;


        repeat(4) @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Mod 5, No Delay - Expect cout=1 after 5 cycles", test_num);
        initial_value = 32'd1;
        modulus = 32'd5;
        time_delay = 32'd0;
        reset = 1; #20; reset = 0;

        repeat(5) @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Mod 2, Delay 15ns - Expect cout=0 before delay expires", test_num);
        initial_value = 32'd1;
        modulus = 32'd2;
        time_delay = 32'd15;
        reset = 1; #20; reset = 0;

        repeat(2) @(posedge clk);
        #5;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Mod 2, Delay 15ns - Expect cout=1 after delay expires", test_num);
        initial_value = 32'd1;
        modulus = 32'd2;
        time_delay = 32'd15;
        reset = 1; #20; reset = 0;

        repeat(2) @(posedge clk);
        #16;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Init 3, Mod 5 - Expect toggle after 3 edges", test_num);
        initial_value = 32'd3;
        modulus = 32'd5;
        time_delay = 32'd0;
        reset = 1; #20; reset = 0;


        repeat(3) @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
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
        input expected_cout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout)) begin
                $display("PASS");
                $display("  Outputs: cout=%b",
                         cout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b",
                         expected_cout);
                $display("  Got:      cout=%b",
                         cout);
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
