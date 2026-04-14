`timescale 1ns/1ps

module fixed_priority_arbiter_tb;

    // Testbench signals (sequential circuit)
    reg R0;
    reg R1;
    reg R2;
    reg clk;
    reg reset;
    wire G0;
    wire G1;
    wire G2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fixed_priority_arbiter dut (
        .R0(R0),
        .R1(R1),
        .R2(R2),
        .clk(clk),
        .reset(reset),
        .G0(G0),
        .G1(G1),
        .G2(G2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            R0 = 0;
            R1 = 0;
            R2 = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No requests", test_num);
            reset_dut();
            R0 = 0; R1 = 0; R2 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: R0 only", test_num);
            reset_dut();
            R0 = 1; R1 = 0; R2 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: R1 only", test_num);
            reset_dut();
            R0 = 0; R1 = 1; R2 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: R2 only", test_num);
            reset_dut();
            R0 = 0; R1 = 0; R2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: R0 and R1 conflict", test_num);
            reset_dut();
            R0 = 1; R1 = 1; R2 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: R0 and R2 conflict", test_num);
            reset_dut();
            R0 = 1; R1 = 0; R2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: R1 and R2 conflict", test_num);
            reset_dut();
            R0 = 0; R1 = 1; R2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All requests (R0, R1, R2)", test_num);
            reset_dut();
            R0 = 1; R1 = 1; R2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequence check R2 -> R1", test_num);
            reset_dut();
            R2 = 1;
            @(posedge clk);
            #1;
            if (G2 !== 1) $display("Intermediate fail: G2 should be 1");

            R1 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fixed_priority_arbiter Testbench");
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
        input expected_G0;
        input expected_G1;
        input expected_G2;
        begin
            if (expected_G0 === (expected_G0 ^ G0 ^ expected_G0) &&
                expected_G1 === (expected_G1 ^ G1 ^ expected_G1) &&
                expected_G2 === (expected_G2 ^ G2 ^ expected_G2)) begin
                $display("PASS");
                $display("  Outputs: G0=%b, G1=%b, G2=%b",
                         G0, G1, G2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: G0=%b, G1=%b, G2=%b",
                         expected_G0, expected_G1, expected_G2);
                $display("  Got:      G0=%b, G1=%b, G2=%b",
                         G0, G1, G2);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,R0, R1, R2, clk, reset, G0, G1, G2);
    end

endmodule
