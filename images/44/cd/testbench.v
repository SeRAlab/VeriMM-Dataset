`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg c0;
    reg c1;
    reg c2;
    reg c3;
    reg s0;
    reg s1;
    wire [5:0] led;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c0(c0),
        .c1(c1),
        .c2(c2),
        .c3(c3),
        .s0(s0),
        .s1(s1),
        .led(led),
        .z(z)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select c0, set c0=1, others=0", test_num);
            c0 = 1; c1 = 0; c2 = 0; c3 = 0;
            s1 = 0; s0 = 0;

            #1;


            check_outputs(6'b100000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select c1, set c1=1, others=0", test_num);
            c0 = 0; c1 = 1; c2 = 0; c3 = 0;
            s1 = 0; s0 = 1;

            #1;


            check_outputs(6'b010001, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select c2, set c2=1, others=0", test_num);
            c0 = 0; c1 = 0; c2 = 1; c3 = 0;
            s1 = 1; s0 = 0;

            #1;


            check_outputs(6'b001010, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select c3, set c3=1, others=0", test_num);
            c0 = 0; c1 = 0; c2 = 0; c3 = 1;
            s1 = 1; s0 = 1;

            #1;


            check_outputs(6'b000111, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select c0, but c0=0 and others=1", test_num);
            c0 = 0; c1 = 1; c2 = 1; c3 = 1;
            s1 = 0; s0 = 0;

            #1;


            check_outputs(6'b011100, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select c1, but c1=0 and others=1", test_num);
            c0 = 1; c1 = 0; c2 = 1; c3 = 1;
            s1 = 0; s0 = 1;

            #1;


            check_outputs(6'b101101, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select c2, but c2=0 and others=1", test_num);
            c0 = 1; c1 = 1; c2 = 0; c3 = 1;
            s1 = 1; s0 = 0;

            #1;


            check_outputs(6'b110110, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select c3, but c3=0 and others=1", test_num);
            c0 = 1; c1 = 1; c2 = 1; c3 = 0;
            s1 = 1; s0 = 1;

            #1;


            check_outputs(6'b111011, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs 1, Select c1", test_num);
            c0 = 1; c1 = 1; c2 = 1; c3 = 1;
            s1 = 0; s0 = 1;

            #1;


            check_outputs(6'b111101, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs 0, Select c2", test_num);
            c0 = 0; c1 = 0; c2 = 0; c3 = 0;
            s1 = 1; s0 = 0;

            #1;


            check_outputs(6'b000010, 1'b0);
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
        input [5:0] expected_led;
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_led === (expected_led ^ led ^ expected_led) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: led=%h, z=%b",
                         led, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led=%h, z=%b",
                         expected_led, expected_z);
                $display("  Got:      led=%h, z=%b",
                         led, z);
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
