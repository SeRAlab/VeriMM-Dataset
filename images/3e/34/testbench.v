`timescale 1ns/1ps

module siso_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg Din;
    reg Reset;
    wire Dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    siso_shift_register dut (
        .Clk(Clk),
        .Din(Din),
        .Reset(Reset),
        .Dout(Dout)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Reset = 1;
            Din = 0;
            @(posedge Clk);
            #1 Reset = 0;
            @(posedge Clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Checking Reset state...");
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Shifting 1 through 4 stages...");
            reset_dut();
            Din = 1; @(posedge Clk);
            Din = 0; @(posedge Clk);
            Din = 0; @(posedge Clk);
            Din = 0; @(posedge Clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Verifying 0 bit propagation...");
            reset_dut();
            Din = 0; @(posedge Clk);
            Din = 1; @(posedge Clk);
            Din = 1; @(posedge Clk);
            Din = 1; @(posedge Clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Filling register with 1s...");
            reset_dut();
            Din = 1; @(posedge Clk);
            Din = 1; @(posedge Clk);
            Din = 1; @(posedge Clk);
            Din = 1; @(posedge Clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Resetting while register is full...");
            reset_dut();

            Din = 1; repeat(4) @(posedge Clk);

            Reset = 1;
            @(posedge Clk);
            #1 Reset = 0;
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
        $display("siso_shift_register Testbench");
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
        input expected_Dout;
        begin
            if (expected_Dout === (expected_Dout ^ Dout ^ expected_Dout)) begin
                $display("PASS");
                $display("  Outputs: Dout=%b",
                         Dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Dout=%b",
                         expected_Dout);
                $display("  Got:      Dout=%b",
                         Dout);
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
        $dumpvars(0,Clk, Din, Reset, Dout);
    end

endmodule
