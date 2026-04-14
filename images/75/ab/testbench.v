`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] s;
    reg [17:0] x;
    reg [17:0] y;
    wire v;
    wire [17:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .s(s),
        .x(x),
        .y(y),
        .v(v),
        .z(z)
    );
    task testcase001;

        begin
            test_num = 1;
            s = 2'b00; x = 18'sd5000; y = 18'sd4000;
            #1;
            #1;

            check_outputs(1'b0, 18'sd9000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            s = 2'b00; x = 18'sd60000; y = 18'sd40000;
            #1;
            #1;

            check_outputs(1'b1, 18'sd100000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            s = 2'b01; x = 18'sd5000; y = 18'sd2000;
            #1;
            #1;

            check_outputs(1'b0, 18'sd3000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            s = 2'b01; x = 18'sd1000; y = 18'sd12000;
            #1;
            #1;

            check_outputs(1'b1, 18'sd-11000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            s = 2'b10; x = 18'sd100; y = 18'sd50;
            #1;
            #1;

            check_outputs(1'b0, 18'sd5000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            s = 2'b10; x = 18'sd1000; y = 18'sd120;
            #1;
            #1;

            check_outputs(1'b1, 18'sd120000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            s = 2'b10; x = 18'sd200; y = -18'sd60;
            #1;
            #1;

            check_outputs(1'b1, 18'sd-12000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            s = 2'b11; x = 18'sd80000; y = 18'sd10;
            #1;
            #1;

            check_outputs(1'b0, 18'sd8000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            s = 2'b11; x = 18'sd99999; y = 18'sd1;
            #1;
            #1;

            check_outputs(1'b0, 18'sd99999);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            s = 2'b11; x = -18'sd9999; y = 18'sd1;
            #1;
            #1;

            check_outputs(1'b0, 18'sd-9999);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            s = 2'b11; x = 18'sd0; y = 18'sd500;
            #1;
            #1;

            check_outputs(1'b0, 18'sd0);
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
        testcase011();
        
        
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
        input expected_v;
        input [17:0] expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_v === (expected_v ^ v ^ expected_v) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: v=%b, z=%h",
                         v, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: v=%b, z=%h",
                         expected_v, expected_z);
                $display("  Got:      v=%b, z=%h",
                         v, z);
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
