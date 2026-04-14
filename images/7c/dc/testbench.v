`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] RM;
    reg beat;
    reg mod;
    wire [15:0] R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RM(RM),
        .beat(beat),
        .mod(mod),
        .R(R)
    );
    task testcase001;

        integer i;
        begin
            $display("Running testcase001: Mod signal priority check...");
            mod = 1'b1;
            for (i = 0; i < 8; i = i + 1) begin
                test_num = test_num + 1;
                RM = i[2:0];
                beat = i[0];
                #1;

                check_outputs(get_expected(RM, mod, beat));
            end
        end
        endtask

    task testcase002;

        integer i;
        begin
            $display("Running testcase002: Beat 0 decoding (Lower 8-bit patterns)...");
            mod = 1'b0;
            beat = 1'b0;
            for (i = 0; i < 8; i = i + 1) begin
                test_num = test_num + 1;
                RM = i[2:0];
                #1;

                check_outputs(get_expected(RM, mod, beat));
            end
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Running testcase003: Beat 1 decoding (Upper 8-bit patterns)...");
            mod = 1'b0;
            beat = 1'b1;
            for (i = 0; i < 8; i = i + 1) begin
                test_num = test_num + 1;
                RM = i[2:0];
                #1;

                check_outputs(get_expected(RM, mod, beat));
            end
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Control signal transitions...");


            mod = 1'b1; RM = 3'b111; beat = 1'b1;
            #5;
            mod = 1'b0;
            test_num = test_num + 1;
            #1;

            check_outputs(get_expected(RM, mod, beat));


            #5;
            beat = 1'b0;
            test_num = test_num + 1;
            #1;

            check_outputs(get_expected(RM, mod, beat));


            #5;
            RM = 3'b010;
            test_num = test_num + 1;
            #1;

            check_outputs(get_expected(RM, mod, beat));
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
        input [15:0] expected_R;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_R === (expected_R ^ R ^ expected_R)) begin
                $display("PASS");
                $display("  Outputs: R=%h",
                         R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: R=%h",
                         expected_R);
                $display("  Got:      R=%h",
                         R);
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
