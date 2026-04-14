`timescale 1ns/1ps

module shift_register_3bit_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RESET;
    reg SIN;
    wire [2:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_3bit dut (
        .CLK(CLK),
        .RESET(RESET),
        .SIN(SIN),
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
            RESET = 1;
            SIN = 0;
            @(negedge CLK);
            RESET = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Resetting register...", test_num);
            reset_dut();

            #1;


            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Shifting in pattern 1-0-1...", test_num);
            reset_dut();

            @(negedge CLK) SIN = 1;
            @(negedge CLK) SIN = 0;
            @(negedge CLK) SIN = 1;

            @(posedge CLK);
            #1;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Filling register with 1s...", test_num);
            reset_dut();

            @(negedge CLK) SIN = 1;
            @(negedge CLK) SIN = 1;
            @(negedge CLK) SIN = 1;

            @(posedge CLK);
            #1;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Shifting 4 bits (1-1-0-1) into 3-bit register...", test_num);
            reset_dut();

            @(negedge CLK) SIN = 1;
            @(negedge CLK) SIN = 1;
            @(negedge CLK) SIN = 0;
            @(negedge CLK) SIN = 1;

            @(posedge CLK);
            #1;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Shift in 1s then shift in 0s...", test_num);
            reset_dut();


            @(negedge CLK) SIN = 1;
            @(negedge CLK) SIN = 1;
            @(negedge CLK) SIN = 1;

            @(negedge CLK) SIN = 0;
            @(negedge CLK) SIN = 0;

            @(posedge CLK);
            #1;
            #1;

            check_outputs(3'b100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_3bit Testbench");
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
        input [2:0] expected_Q;
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
        $dumpvars(0,CLK, RESET, SIN, Q);
    end

endmodule
