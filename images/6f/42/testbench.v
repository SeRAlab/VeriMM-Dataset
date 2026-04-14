`timescale 1ns/1ps

module shift_reg_4bit_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg SI;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg_4bit dut (
        .CLK(CLK),
        .SI(SI),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            @(negedge CLK);
            SI = 0;
            repeat (4) @(negedge CLK);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Shift 1111");
            reset_dut();
            test_num = test_num + 1;

            @(negedge CLK) SI = 1;
            @(negedge CLK) SI = 1;
            @(negedge CLK) SI = 1;
            @(negedge CLK) SI = 1;

            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Shift 1011");
            reset_dut();
            test_num = test_num + 1;

            @(negedge CLK) SI = 1;
            @(negedge CLK) SI = 0;
            @(negedge CLK) SI = 1;
            @(negedge CLK) SI = 1;

            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Shift 0101");
            reset_dut();
            test_num = test_num + 1;

            @(negedge CLK) SI = 0;
            @(negedge CLK) SI = 1;
            @(negedge CLK) SI = 0;
            @(negedge CLK) SI = 1;

            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Overflow (Shift 1100 then 1)");
            reset_dut();
            test_num = test_num + 1;

            @(negedge CLK) SI = 1;
            @(negedge CLK) SI = 1;
            @(negedge CLK) SI = 0;
            @(negedge CLK) SI = 0;
            @(negedge CLK) SI = 1;

            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'b1001);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Shift 1010 then shift in two zeros");
            reset_dut();
            test_num = test_num + 1;


            @(negedge CLK) SI = 1;
            @(negedge CLK) SI = 0;
            @(negedge CLK) SI = 1;
            @(negedge CLK) SI = 0;

            @(negedge CLK) SI = 0;
            @(negedge CLK) SI = 0;

            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_reg_4bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [3:0] expected_Q;
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
        $dumpvars(0,CLK, SI, Q);
    end

endmodule
