`timescale 1ns/1ps

module custom_logic_tb;

    // Testbench signals (combinational circuit)
    reg g;
    reg h;
    reg i;
    reg j;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    custom_logic dut (
        .g(g),
        .h(h),
        .i(i),
        .j(j),
        .z(z)
    );
    task testcase001;

        begin
            $display("Testcase 001: g=1, h=0, i=1, j=1");
            g = 1; h = 0; i = 1; j = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: g=0, h=1, i=0, j=1");
            g = 0; h = 1; i = 0; j = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: g=1, h=1, i=1, j=0");
            g = 1; h = 1; i = 1; j = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: g=0, h=0, i=1, j=0");
            g = 0; h = 0; i = 1; j = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: g=1, h=0, i=0, j=0");
            g = 1; h = 0; i = 0; j = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: g=0, h=1, i=1, j=1");
            g = 0; h = 1; i = 1; j = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: g=1, h=1, i=0, j=1");
            g = 1; h = 1; i = 0; j = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: g=0, h=0, i=0, j=1");
            g = 0; h = 0; i = 0; j = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: g=1, h=0, i=1, j=0");
            g = 1; h = 0; i = 1; j = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: g=0, h=1, i=1, j=0");
            g = 0; h = 1; i = 1; j = 0;
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
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: z=%b",
                         z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z=%b",
                         expected_z);
                $display("  Got:      z=%b",
                         z);
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
