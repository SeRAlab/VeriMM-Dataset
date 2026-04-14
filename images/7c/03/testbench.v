`timescale 1ns/1ps

module fsm_example3_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg g;
    reg [2:0] t;
    wire T1;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fsm_example3 dut (
        .clk(clk),
        .g(g),
        .t(t),
        .T1(T1),
        .z(z)
    );
    task testcase001;

        begin
            test_num = 1;
            t = 3'b000; g = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            t = 3'b000; g = 1;
            #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            t = 3'b001; g = 0;
            #10;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            t = 3'b001; g = 1;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            t = 3'b010; g = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            t = 3'b010; g = 1;
            #10;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            t = 3'b011; g = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            t = 3'b011; g = 1;
            #10;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            t = 3'b100; g = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            t = 3'b100; g = 1;
            #10;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fsm_example3 Testbench");
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
        input expected_T1;
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_T1 === (expected_T1 ^ T1 ^ expected_T1) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: T1=%b, z=%b",
                         T1, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: T1=%b, z=%b",
                         expected_T1, expected_z);
                $display("  Got:      T1=%b, z=%b",
                         T1, z);
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
