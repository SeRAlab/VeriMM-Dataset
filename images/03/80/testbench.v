`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] IRQ;
    reg RST;
    wire INT_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .CLK(CLK),
        .IRQ(IRQ),
        .RST(RST),
        .INT_OUT(INT_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            IRQ = 4'b0000;
            @(posedge CLK);
            #1;
            RST = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Idle state after reset");
            reset_dut();
            IRQ = 4'b0000;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: IRQ[0] asserted");
            reset_dut();
            IRQ = 4'b0001;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: IRQ[3] asserted");
            reset_dut();
            IRQ = 4'b1000;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Multiple IRQs asserted");
            reset_dut();
            IRQ = 4'b1011;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Reset priority over IRQ");
            reset_dut();
            IRQ = 4'b1111;
            @(posedge CLK);
            #1;
            RST = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0);
            RST = 0;
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: All IRQs asserted");
            reset_dut();
            IRQ = 4'b1111;
            @(posedge CLK);
            #1;
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
        $display("interrupt_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input expected_INT_OUT;
        begin
            if (expected_INT_OUT === (expected_INT_OUT ^ INT_OUT ^ expected_INT_OUT)) begin
                $display("PASS");
                $display("  Outputs: INT_OUT=%b",
                         INT_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: INT_OUT=%b",
                         expected_INT_OUT);
                $display("  Got:      INT_OUT=%b",
                         INT_OUT);
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
        $dumpvars(0,CLK, IRQ, RST, INT_OUT);
    end

endmodule
