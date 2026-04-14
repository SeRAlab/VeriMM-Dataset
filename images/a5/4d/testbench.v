`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [6:0] din;
    reg rin;
    wire [6:0] qout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .din(din),
        .rin(rin),
        .qout(qout)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            @(posedge clock);
            rin <= 1;
            din <= 7'b0;
            @(posedge clock);
            rin <= 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Load (0x5A)", test_num);
            reset_dut();

            @(negedge clock);
            rin <= 1;
            din <= 7'h5A;

            @(posedge clock);
            #1;
            #1;

            check_outputs(7'h5A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Hold Value (Load 0x33 then hold)", test_num);
            reset_dut();


            @(negedge clock);
            rin <= 1;
            din <= 7'h33;
            @(posedge clock);


            @(negedge clock);
            rin <= 0;
            din <= 7'h7F;

            @(posedge clock);
            #1;
            #1;

            check_outputs(7'h33);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Load Max Value (0x7F)", test_num);
            reset_dut();

            @(negedge clock);
            rin <= 1;
            din <= 7'h7F;

            @(posedge clock);
            #1;
            #1;

            check_outputs(7'h7F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Hold value across 3 cycles", test_num);
            reset_dut();


            @(negedge clock);
            rin <= 1;
            din <= 7'h12;
            @(posedge clock);


            @(negedge clock);
            rin <= 0;
            din <= 7'h01;
            @(posedge clock);

            @(negedge clock);
            din <= 7'h02;
            @(posedge clock);

            @(negedge clock);
            din <= 7'h03;
            @(posedge clock);

            #1;
            #1;

            check_outputs(7'h12);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Sequential loads back-to-back", test_num);
            reset_dut();

            @(negedge clock);
            rin <= 1;
            din <= 7'h11;
            @(posedge clock);

            @(negedge clock);
            din <= 7'h22;
            @(posedge clock);

            @(negedge clock);
            din <= 7'h44;
            @(posedge clock);

            #1;
            #1;

            check_outputs(7'h44);
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
        input [6:0] expected_qout;
        begin
            if (expected_qout === (expected_qout ^ qout ^ expected_qout)) begin
                $display("PASS");
                $display("  Outputs: qout=%h",
                         qout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: qout=%h",
                         expected_qout);
                $display("  Got:      qout=%h",
                         qout);
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
        $dumpvars(0,clock, din, rin, qout);
    end

endmodule
