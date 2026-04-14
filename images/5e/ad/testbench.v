`timescale 1ns/1ps

module fsm_logic_verilog_tb;

    // Testbench signals (combinational circuit)
    reg g;
    reg [1:0] z;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fsm_logic_verilog dut (
        .g(g),
        .z(z),
        .Y(Y)
    );
    task testcase001;

        begin
            $display("Test 001: State F (z=00), g=0 -> Next state G (z=01), Expected next z[1]=0");
            test_num = 1;
            z = 2'b00; g = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Test 002: State F (z=00), g=1 -> Next state H (z=10), Expected next z[1]=1");
            test_num = 2;
            z = 2'b00; g = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Test 003: State G (z=01), g=0 -> Next state I (z=11), Expected next z[1]=1");
            test_num = 3;
            z = 2'b01; g = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Test 004: State G (z=01), g=1 -> Next state F (z=00), Expected next z[1]=0");
            test_num = 4;
            z = 2'b01; g = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Test 005: State H (z=10), g=0 -> Next state I (z=11), Expected next z[1]=1");
            test_num = 5;
            z = 2'b10; g = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Test 006: State H (z=10), g=1 -> Next state G (z=01), Expected next z[1]=0");
            test_num = 6;
            z = 2'b10; g = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Test 007: State I (z=11), g=0 -> Next state H (z=10), Expected next z[1]=1");
            test_num = 7;
            z = 2'b11; g = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Test 008: State I (z=11), g=1 -> Next state F (z=00), Expected next z[1]=0");
            test_num = 8;
            z = 2'b11; g = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fsm_logic_verilog Testbench");
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
