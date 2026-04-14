`timescale 1ns/1ps

module dac_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] control;
    wire [7:0] voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dac_8bit dut (
        .control(control),
        .voltage(voltage)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Control = 000 (Level 0)", test_num);
            control = 3'b000;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Control = 001 (Level 1)", test_num);
            control = 3'b001;
            #1;

            check_outputs(8'd32);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Control = 010 (Level 2)", test_num);
            control = 3'b010;
            #1;

            check_outputs(8'd64);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Control = 011 (Level 3)", test_num);
            control = 3'b011;
            #1;

            check_outputs(8'd96);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Control = 100 (Level 4)", test_num);
            control = 3'b100;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Control = 101 (Level 5)", test_num);
            control = 3'b101;
            #1;

            check_outputs(8'd160);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Control = 110 (Level 6)", test_num);
            control = 3'b110;
            #1;

            check_outputs(8'd192);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Control = 111 (Level 7)", test_num);
            control = 3'b111;
            #1;

            check_outputs(8'd224);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dac_8bit Testbench");
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
        input [7:0] expected_voltage;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_voltage === (expected_voltage ^ voltage ^ expected_voltage)) begin
                $display("PASS");
                $display("  Outputs: voltage=%h",
                         voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: voltage=%h",
                         expected_voltage);
                $display("  Got:      voltage=%h",
                         voltage);
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
