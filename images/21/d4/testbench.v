`timescale 1ns/1ps

module linear_voltage_regulator_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] voltage_in;
    wire [4:0] voltage_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_voltage_regulator dut (
        .voltage_in(voltage_in),
        .voltage_out(voltage_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 00000 (0V)", test_num);
            voltage_in = 5'b00000;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 00011 (3V)", test_num);
            voltage_in = 5'b00011;
            #1;

            check_outputs(5'b00011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 00100 (Plateau 3V)", test_num);
            voltage_in = 5'b00100;
            #1;

            check_outputs(5'b00011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 00110 (Plateau 3V)", test_num);
            voltage_in = 5'b00110;
            #1;

            check_outputs(5'b00011);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 00111 (4V)", test_num);
            voltage_in = 5'b00111;
            #1;

            check_outputs(5'b00100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 01010 (6V)", test_num);
            voltage_in = 5'b01010;
            #1;

            check_outputs(5'b00110);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 01110 (7V plateau)", test_num);
            voltage_in = 5'b01110;
            #1;

            check_outputs(5'b00111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 10000 (9V)", test_num);
            voltage_in = 5'b10000;
            #1;

            check_outputs(5'b01001);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 10011 (12V)", test_num);
            voltage_in = 5'b10011;
            #1;

            check_outputs(5'b01100);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 10110 (14V plateau)", test_num);
            voltage_in = 5'b10110;
            #1;

            check_outputs(5'b01110);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 11011 (18V plateau)", test_num);
            voltage_in = 5'b11011;
            #1;

            check_outputs(5'b10010);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 11101 (19V plateau)", test_num);
            voltage_in = 5'b11101;
            #1;

            check_outputs(5'b10011);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 11111 (21V)", test_num);
            voltage_in = 5'b11111;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("linear_voltage_regulator Testbench");
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
        testcase012();
        testcase013();
        
        
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
        input [4:0] expected_voltage_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_voltage_out === (expected_voltage_out ^ voltage_out ^ expected_voltage_out)) begin
                $display("PASS");
                $display("  Outputs: voltage_out=%h",
                         voltage_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: voltage_out=%h",
                         expected_voltage_out);
                $display("  Got:      voltage_out=%h",
                         voltage_out);
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
