`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] switch;
    wire [9:0] light;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .switch(switch),
        .light(light)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            switch = 10'b00_0000_0000;
            #1;

            check_outputs(10'b00_0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            switch = 10'b11_1111_1111;
            #1;

            check_outputs(10'b11_1111_1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checkerboard Pattern 1", test_num);
            switch = 10'b10_1010_1010;
            #1;

            check_outputs(10'b10_1010_1010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checkerboard Pattern 2", test_num);
            switch = 10'b01_0101_0101;
            #1;

            check_outputs(10'b01_0101_0101);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking Bit 0", test_num);
            switch = 10'b00_0000_0001;
            #1;

            check_outputs(10'b00_0000_0001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking Bit 9", test_num);
            switch = 10'b10_0000_0000;
            #1;

            check_outputs(10'b10_0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary Pattern", test_num);
            switch = 10'h1A3;
            #1;

            check_outputs(10'h1A3);
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
        input [9:0] expected_light;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_light === (expected_light ^ light ^ expected_light)) begin
                $display("PASS");
                $display("  Outputs: light=%h",
                         light);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: light=%h",
                         expected_light);
                $display("  Got:      light=%h",
                         light);
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
