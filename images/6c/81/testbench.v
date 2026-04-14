`timescale 1ns/1ps

module custom_logic_tb;

    // Testbench signals (combinational circuit)
    reg b;
    reg c;
    reg d;
    reg e;
    wire status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    custom_logic dut (
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .status(status)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: b=1, c=1, d=0, e=0", test_num);
            b = 1; c = 1; d = 0; e = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: b=0, c=0, d=1, e=1", test_num);
            b = 0; c = 0; d = 1; e = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: b=1, c=0, d=1, e=0", test_num);
            b = 1; c = 0; d = 1; e = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: b=0, c=1, d=0, e=1", test_num);
            b = 0; c = 1; d = 0; e = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: b=1, c=1, d=1, e=1", test_num);
            b = 1; c = 1; d = 1; e = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: b=0, c=0, d=0, e=0", test_num);
            b = 0; c = 0; d = 0; e = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: b=1, c=0, d=0, e=1", test_num);
            b = 1; c = 0; d = 0; e = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: b=0, c=1, d=1, e=0", test_num);
            b = 0; c = 1; d = 1; e = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: b=1, c=1, d=0, e=1", test_num);
            b = 1; c = 1; d = 0; e = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: b=0, c=0, d=1, e=0", test_num);
            b = 0; c = 0; d = 1; e = 0;
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
        $display("custom_logic Testbench");
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
        input expected_status;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: status=%b",
                         status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: status=%b",
                         expected_status);
                $display("  Got:      status=%b",
                         status);
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
