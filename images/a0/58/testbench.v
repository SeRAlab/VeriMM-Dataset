`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] x;
    reg [15:0] y;
    wire [15:0] v;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .v(v)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Positive values (x=1, y=2)", test_num);
        x = 16'd1;
        y = 16'd2;

        #1;


        check_outputs(16'd30);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero values (x=0, y=0)", test_num);
        x = 16'd0;
        y = 16'd0;

        #1;


        check_outputs(16'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Negative values (x=-5, y=-5)", test_num);
        x = -16'sd5;
        y = -16'sd5;

        #1;


        check_outputs(-16'sd100);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mixed signs (x=20, y=-10)", test_num);
        x = 16'sd20;
        y = -16'sd10;

        #1;


        check_outputs(16'sd100);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Large positive (x=2000, y=1000)", test_num);
        x = 16'sd2000;
        y = 16'sd1000;

        #1;


        check_outputs(16'sd30000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Large negative (x=-1500, y=-1500)", test_num);
        x = -16'sd1500;
        y = -16'sd1500;

        #1;


        check_outputs(-16'sd30000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max positive edge (x=3000, y=276)", test_num);
        x = 16'sd3000;
        y = 16'sd276;

        #1;


        check_outputs(16'sd32760);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Min negative edge (x=-3000, y=-276)", test_num);
        x = -16'sd3000;
        y = -16'sd276;

        #1;


        check_outputs(-16'sd32760);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Positive Overflow Truncation", test_num);
        x = 16'sd10000;
        y = 16'sd10000;



        #1;




        check_outputs(16'h0D40);
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
        input [15:0] expected_v;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_v === (expected_v ^ v ^ expected_v)) begin
                $display("PASS");
                $display("  Outputs: v=%h",
                         v);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: v=%h",
                         expected_v);
                $display("  Got:      v=%h",
                         v);
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
