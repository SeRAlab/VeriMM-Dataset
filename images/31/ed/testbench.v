`timescale 1ns/1ps

module parity_checker_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data;
    wire parity;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    parity_checker dut (
        .data(data),
        .parity(parity)
    );
    task testcase001;

        begin
            test_num = 1;
            data = 4'b0000;
            $display("Testcase %0d: data=%b (0 ones)", test_num, data);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data = 4'b0001;
            $display("Testcase %0d: data=%b (1 one)", test_num, data);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data = 4'b0011;
            $display("Testcase %0d: data=%b (2 ones)", test_num, data);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data = 4'b0111;
            $display("Testcase %0d: data=%b (3 ones)", test_num, data);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data = 4'b1111;
            $display("Testcase %0d: data=%b (4 ones)", test_num, data);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data = 4'b1010;
            $display("Testcase %0d: data=%b (2 ones)", test_num, data);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data = 4'b1000;
            $display("Testcase %0d: data=%b (1 one)", test_num, data);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            data = 4'b1101;
            $display("Testcase %0d: data=%b (3 ones)", test_num, data);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            data = 4'b0110;
            $display("Testcase %0d: data=%b (2 ones)", test_num, data);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            data = 4'b1011;
            $display("Testcase %0d: data=%b (3 ones)", test_num, data);
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
        $display("parity_checker Testbench");
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
        input expected_parity;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_parity === (expected_parity ^ parity ^ expected_parity)) begin
                $display("PASS");
                $display("  Outputs: parity=%b",
                         parity);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parity=%b",
                         expected_parity);
                $display("  Got:      parity=%b",
                         parity);
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
