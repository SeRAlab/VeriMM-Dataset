`timescale 1ns/1ps

module voltage_regulator_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] voltage_ref;
    wire [4:0] regulated_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_regulator dut (
        .voltage_ref(voltage_ref),
        .regulated_output(regulated_output)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Input 00000 (0V)", test_num);
            voltage_ref = 5'b00000;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Input 00001 (1V)", test_num);
            voltage_ref = 5'b00001;
            #1;

            check_outputs(5'b00001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Input 00101 (5V)", test_num);
            voltage_ref = 5'b00101;
            #1;

            check_outputs(5'b00101);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Input 01010 (10V)", test_num);
            voltage_ref = 5'b01010;
            #1;

            check_outputs(5'b01010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Input 01111 (15V)", test_num);
            voltage_ref = 5'b01111;
            #1;

            check_outputs(5'b01111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Input 10000 (16V)", test_num);
            voltage_ref = 5'b10000;
            #1;

            check_outputs(5'b10000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Input 10111 (23V)", test_num);
            voltage_ref = 5'b10111;
            #1;

            check_outputs(5'b10111);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Input 11001 (25V)", test_num);
            voltage_ref = 5'b11001;
            #1;

            check_outputs(5'b11001);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Input 11110 (30V)", test_num);
            voltage_ref = 5'b11110;
            #1;

            check_outputs(5'b11110);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Input 11111 (31V)", test_num);
            voltage_ref = 5'b11111;
            #1;

            check_outputs(5'b11111);
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
        input [4:0] expected_regulated_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_regulated_output === (expected_regulated_output ^ regulated_output ^ expected_regulated_output)) begin
                $display("PASS");
                $display("  Outputs: regulated_output=%h",
                         regulated_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: regulated_output=%h",
                         expected_regulated_output);
                $display("  Got:      regulated_output=%h",
                         regulated_output);
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
