`timescale 1ns/1ps

module temperature_shutdown_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] temperature;
    wire shutdown_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temperature_shutdown dut (
        .temperature(temperature),
        .shutdown_signal(shutdown_signal)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Temperature = 0 (Expect Shutdown = 0)", test_num);
            temperature = 8'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Temperature = 25 (Expect Shutdown = 0)", test_num);
            temperature = 8'd25;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Temperature = 74 (Expect Shutdown = 0)", test_num);
            temperature = 8'd74;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Temperature = 75 (Expect Shutdown = 0)", test_num);
            temperature = 8'd75;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Temperature = 76 (Expect Shutdown = 1)", test_num);
            temperature = 8'd76;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Temperature = 100 (Expect Shutdown = 1)", test_num);
            temperature = 8'd100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Temperature = 255 (Expect Shutdown = 1)", test_num);
            temperature = 8'd255;
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
        $display("temperature_shutdown Testbench");
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
        input expected_shutdown_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_shutdown_signal === (expected_shutdown_signal ^ shutdown_signal ^ expected_shutdown_signal)) begin
                $display("PASS");
                $display("  Outputs: shutdown_signal=%b",
                         shutdown_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shutdown_signal=%b",
                         expected_shutdown_signal);
                $display("  Got:      shutdown_signal=%b",
                         shutdown_signal);
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
