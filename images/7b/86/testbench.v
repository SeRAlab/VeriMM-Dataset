`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    wire [6:0] Display;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .Display(Display)
    );

    // Clock generation (10ns period)
    initial begin
        a = 0;
        forever #5 a = ~a;
    end

        task reset_dut;

        integer timeout;
        begin
            timeout = 0;

            while (Display !== SEG0 && timeout < 12) begin
                @(posedge a);
                #1;
                timeout = timeout + 1;
            end
            if (timeout >= 12) $display("Warning: Reset/Sync to 0 failed. Check segment encoding.");
            else $display("DUT synchronized to state 0.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment once from 0 to 1", test_num);
            reset_dut();
            @(posedge a);
            #1;
            #1;

            check_outputs(SEG1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment four times to 4", test_num);
            reset_dut();
            repeat(4) @(posedge a);
            #1;
            #1;

            check_outputs(SEG4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment to maximum value 9", test_num);
            reset_dut();
            repeat(9) @(posedge a);
            #1;
            #1;

            check_outputs(SEG9);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment 10 times to test rollover (9->0)", test_num);
            reset_dut();
            repeat(10) @(posedge a);
            #1;
            #1;

            check_outputs(SEG0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment 12 times (9->0->1->2)", test_num);
            reset_dut();
            repeat(12) @(posedge a);
            #1;
            #1;

            check_outputs(SEG2);
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
        input [6:0] expected_Display;
        begin
            if (expected_Display === (expected_Display ^ Display ^ expected_Display)) begin
                $display("PASS");
                $display("  Outputs: Display=%h",
                         Display);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Display=%h",
                         expected_Display);
                $display("  Got:      Display=%h",
                         Display);
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
        $dumpvars(0,a, Display);
    end

endmodule
