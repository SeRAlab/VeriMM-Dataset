`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg si;
    wire [3:0] po;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .si(si),
        .po(po)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            si = 0;
            repeat (4) @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Shift in 1111");
            reset_dut();
            si = 1;
            repeat (4) @(negedge clk);
            #1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Shift in 1010");
            reset_dut();

            si = 1; @(negedge clk);

            si = 0; @(negedge clk);

            si = 1; @(negedge clk);

            si = 0; @(negedge clk);
            #1;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Shift in 0110");
            reset_dut();
            si = 0; @(negedge clk);
            si = 1; @(negedge clk);
            si = 1; @(negedge clk);
            si = 0; @(negedge clk);
            #1;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Shift in 1100");
            reset_dut();
            si = 1; @(negedge clk);
            si = 1; @(negedge clk);
            si = 0; @(negedge clk);
            si = 0; @(negedge clk);
            #1;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Overflow shift (111101)");
            reset_dut();
            si = 1; @(negedge clk);
            si = 1; @(negedge clk);
            si = 1; @(negedge clk);
            si = 1; @(negedge clk);
            si = 0; @(negedge clk);
            si = 1; @(negedge clk);
            #1;
            #1;

            check_outputs(4'b1101);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input [3:0] expected_po;
        begin
            if (expected_po === (expected_po ^ po ^ expected_po)) begin
                $display("PASS");
                $display("  Outputs: po=%h",
                         po);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: po=%h",
                         expected_po);
                $display("  Got:      po=%h",
                         po);
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
        $dumpvars(0,clk, si, po);
    end

endmodule
