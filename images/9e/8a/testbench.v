`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] pm0;
    reg [3:0] pm1;
    reg [3:0] pm2;
    reg [3:0] pm3;
    wire d0;
    wire d1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pm0(pm0),
        .pm1(pm1),
        .pm2(pm2),
        .pm3(pm3),
        .d0(d0),
        .d1(d1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All inputs zero", test_num);
            pm0 = 4'b0000; pm1 = 4'b0000; pm2 = 4'b0000; pm3 = 4'b0000;
            #10;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All inputs 4'hF", test_num);
            pm0 = 4'b1111; pm1 = 4'b1111; pm2 = 4'b1111; pm3 = 4'b1111;
            #10;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: PM0 bit 0 vs bit 3", test_num);
            pm0 = 4'b0001; pm1 = 4'b0000; pm2 = 4'b0000; pm3 = 4'b0000;
            #10;

            #1;


            check_outputs(1'b1, 1'b0);

            pm0 = 4'b1000;
            #10;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: PM1 bit 1 vs bit 2", test_num);
            pm0 = 4'b0000; pm1 = 4'b0010; pm2 = 4'b0000; pm3 = 4'b0000;
            #10;
            #1;

            check_outputs(1'b1, 1'b0);

            pm1 = 4'b0100;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: PM2 bit 2 vs bit 1", test_num);
            pm0 = 4'b0000; pm1 = 4'b0000; pm2 = 4'b0100; pm3 = 4'b0000;
            #10;
            #1;

            check_outputs(1'b1, 1'b0);

            pm2 = 4'b0010;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: PM3 bit 3 vs bit 0", test_num);
            pm0 = 4'b0000; pm1 = 4'b0000; pm2 = 4'b0000; pm3 = 4'b1000;
            #10;
            #1;

            check_outputs(1'b1, 1'b0);

            pm3 = 4'b0001;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating pattern 4'h5", test_num);
            pm0 = 4'h5; pm1 = 4'h5; pm2 = 4'h5; pm3 = 4'h5;
            #10;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Complex mix", test_num);

            pm0 = 4'h1; pm1 = 4'h0; pm2 = 4'h0; pm3 = 4'h1;
            #10;
            #1;

            check_outputs(1'b1, 1'b1);


            pm0 = 4'h0; pm1 = 4'h4; pm2 = 4'h2; pm3 = 4'h0;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_d0;
        input expected_d1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d0 === (expected_d0 ^ d0 ^ expected_d0) &&
                expected_d1 === (expected_d1 ^ d1 ^ expected_d1)) begin
                $display("PASS");
                $display("  Outputs: d0=%b, d1=%b",
                         d0, d1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d0=%b, d1=%b",
                         expected_d0, expected_d1);
                $display("  Got:      d0=%b, d1=%b",
                         d0, d1);
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
