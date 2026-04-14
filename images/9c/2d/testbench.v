`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg iclk;
    reg ipulse;
    reg oclk;
    reg rstn;
    wire opulse;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iclk(iclk),
        .ipulse(ipulse),
        .oclk(oclk),
        .rstn(rstn),
        .opulse(opulse)
    );

    // Clock generation (10ns period)
    initial begin
        iclk = 0;
        forever #5 iclk = ~iclk;
    end

        task reset_dut;

        begin
            rstn = 0;
            ipulse = 0;
            repeat(10) @(posedge iclk);
            #2 rstn = 1;
            repeat(10) @(posedge iclk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initial Reset State Check", test_num);
            reset_dut();

            @(posedge oclk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Pulse Synchronization", test_num);
            reset_dut();


            @(posedge iclk);
            ipulse <= 1'b1;
            @(posedge iclk);
            ipulse <= 1'b0;



            fork : wait_pulse_002
                begin
                    @(posedge opulse);
                    disable wait_pulse_002;
                end
                begin
                    repeat(50) @(posedge oclk);
                    $display("Timeout waiting for opulse");
                    disable wait_pulse_002;
                end
            join

            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pulse Termination Check", test_num);
            reset_dut();

            @(posedge iclk);
            ipulse <= 1'b1;
            @(posedge iclk);
            ipulse <= 1'b0;

            @(posedge opulse);
            @(posedge oclk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: No Pulse Verification", test_num);
            reset_dut();

            repeat(30) @(posedge oclk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple Consecutive Pulses", test_num);
            reset_dut();


            @(posedge iclk);
            ipulse <= 1'b1;
            @(posedge iclk);
            ipulse <= 1'b0;
            @(posedge opulse);


            repeat(10) @(posedge oclk);


            @(posedge iclk);
            ipulse <= 1'b1;
            @(posedge iclk);
            ipulse <= 1'b0;

            fork : wait_pulse_005
                begin
                    @(posedge opulse);
                    disable wait_pulse_005;
                end
                begin
                    repeat(50) @(posedge oclk);
                    disable wait_pulse_005;
                end
            join

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
        input expected_opulse;
        begin
            if (expected_opulse === (expected_opulse ^ opulse ^ expected_opulse)) begin
                $display("PASS");
                $display("  Outputs: opulse=%b",
                         opulse);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: opulse=%b",
                         expected_opulse);
                $display("  Got:      opulse=%b",
                         opulse);
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
        $dumpvars(0,iclk, ipulse, oclk, rstn, opulse);
    end

endmodule
