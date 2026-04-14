`timescale 1ns/1ps

module power_gating_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] block_input;
    reg power_on;
    wire [3:0] block_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating dut (
        .block_input(block_input),
        .power_on(power_on),
        .block_output(block_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power Off, Input 4'b0000", test_num);
            power_on = 1'b0;
            block_input = 4'b0000;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power Off, Input 4'b1111", test_num);
            power_on = 1'b0;
            block_input = 4'b1111;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power Off, Input 4'b1010", test_num);
            power_on = 1'b0;
            block_input = 4'b1010;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power On, Input 4'b0000", test_num);
            power_on = 1'b1;
            block_input = 4'b0000;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power On, Input 4'b1111", test_num);
            power_on = 1'b1;
            block_input = 4'b1111;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power On, Input 4'b0101", test_num);
            power_on = 1'b1;
            block_input = 4'b0101;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power On, Input 4'b1010", test_num);
            power_on = 1'b1;
            block_input = 4'b1010;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition Power On -> Off", test_num);

            power_on = 1'b1;
            block_input = 4'b1100;
            #5;

            power_on = 1'b0;

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition Power Off -> On", test_num);

            power_on = 1'b0;
            block_input = 4'b0011;
            #5;

            power_on = 1'b1;

            #1;


            check_outputs(4'b0011);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("power_gating Testbench");
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
        input [3:0] expected_block_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_block_output === (expected_block_output ^ block_output ^ expected_block_output)) begin
                $display("PASS");
                $display("  Outputs: block_output=%h",
                         block_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: block_output=%h",
                         expected_block_output);
                $display("  Got:      block_output=%h",
                         block_output);
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
