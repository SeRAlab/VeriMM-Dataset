`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg reset;
    reg [9:0] temp_C;
    wire [15:0] temp_F;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .reset(reset),
        .temp_C(temp_C),
        .temp_F(temp_F)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Reset activated", test_num);
            reset = 1;
            temp_C = 10'sd100;
            #10;
            #1;

            check_outputs(16'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: 0C (Freezing point)", test_num);
            reset = 0;
            temp_C = 10'sd0;
            #10;

            #1;


            check_outputs(16'sd32);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: 100C (Boiling point)", test_num);
            reset = 0;
            temp_C = 10'sd100;
            #10;

            #1;


            check_outputs(16'sd212);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: -40C (Equivalence point)", test_num);
            reset = 0;
            temp_C = -10'sd40;
            #10;

            #1;


            check_outputs(-16'sd40);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: 25C (Room temperature)", test_num);
            reset = 0;
            temp_C = 10'sd25;
            #10;

            #1;


            check_outputs(16'sd77);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: 37C (Body temperature - Truncation test)", test_num);
            reset = 0;
            temp_C = 10'sd37;
            #10;
            #1;

            check_outputs(16'sd98);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Maximum Celsius (511C)", test_num);
            reset = 0;
            temp_C = 10'sd511;
            #10;

            #1;


            check_outputs(16'sd951);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Minimum Celsius (-512C)", test_num);
            reset = 0;
            temp_C = -10'sd512;
            #10;

            #1;


            check_outputs(-16'sd889);
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
        input [15:0] expected_temp_F;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_temp_F === (expected_temp_F ^ temp_F ^ expected_temp_F)) begin
                $display("PASS");
                $display("  Outputs: temp_F=%h",
                         temp_F);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: temp_F=%h",
                         expected_temp_F);
                $display("  Got:      temp_F=%h",
                         temp_F);
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
