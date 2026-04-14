`timescale 1ns/1ps

module voltage_regulator_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] V_in;
    wire [2:0] V_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_regulator dut (
        .V_in(V_in),
        .V_out(V_out)
    );
    task testcase001;

        begin
            test_num = 1;
            V_in = 3'd0;
            $display("Test Case %0d: V_in = 0", test_num);
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            V_in = 3'd1;
            $display("Test Case %0d: V_in = 1", test_num);
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            V_in = 3'd2;
            $display("Test Case %0d: V_in = 2", test_num);
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            V_in = 3'd3;
            $display("Test Case %0d: V_in = 3", test_num);
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            V_in = 3'd4;
            $display("Test Case %0d: V_in = 4", test_num);
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            V_in = 3'd5;
            $display("Test Case %0d: V_in = 5", test_num);
            #1;

            check_outputs(3'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            V_in = 3'd6;
            $display("Test Case %0d: V_in = 6", test_num);
            #1;

            check_outputs(3'd6);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            V_in = 3'd7;
            $display("Test Case %0d: V_in = 7", test_num);
            #1;

            check_outputs(3'd6);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("voltage_regulator Testbench");
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
        input [2:0] expected_V_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_V_out === (expected_V_out ^ V_out ^ expected_V_out)) begin
                $display("PASS");
                $display("  Outputs: V_out=%h",
                         V_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: V_out=%h",
                         expected_V_out);
                $display("  Got:      V_out=%h",
                         V_out);
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
