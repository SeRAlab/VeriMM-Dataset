`timescale 1ns/1ps

module ring_counter_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RST;
    wire [11:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ring_counter dut (
        .CLK(CLK),
        .RST(RST),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            @(posedge CLK);
            #1;
            RST = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Initial Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(12'h001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Single Shift (1 clock cycle)", test_num);
            reset_dut();
            @(posedge CLK);
            #1;
            #1;

            check_outputs(12'h002);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Shift to MSB position (11 clock cycles)", test_num);
            reset_dut();
            repeat(11) @(posedge CLK);
            #1;
            #1;

            check_outputs(12'h800);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Wrap-around from MSB to LSB (12 clock cycles)", test_num);
            reset_dut();
            repeat(12) @(posedge CLK);
            #1;
            #1;

            check_outputs(12'h001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Multiple full rotations (25 clock cycles)", test_num);
            reset_dut();
            repeat(25) @(posedge CLK);
            #1;
            #1;

            check_outputs(12'h002);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Mid-sequence Synchronous Reset", test_num);
            reset_dut();
            repeat(5) @(posedge CLK);
            reset_dut();
            repeat(3) @(posedge CLK);
            #1;
            #1;

            check_outputs(12'h008);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Large number of cycles (100 clock cycles)", test_num);
            reset_dut();
            repeat(100) @(posedge CLK);
            #1;
            #1;

            check_outputs(12'h010);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ring_counter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [11:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,CLK, RST, Q);
    end

endmodule
