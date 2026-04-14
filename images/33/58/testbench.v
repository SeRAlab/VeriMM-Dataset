`timescale 1ns/1ps

module sata_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg go_active;
    reg go_suspend;
    reg reset;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sata_controller dut (
        .clk(clk),
        .go_active(go_active),
        .go_suspend(go_suspend),
        .reset(reset),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            go_active = 0;
            go_suspend = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verify Reset state (IDLE)", test_num);
            reset_dut();
            #1;

            check_outputs(IDLE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: IDLE to ACTIVE transition", test_num);
            reset_dut();
            go_active = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(ACTIVE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: ACTIVE to SUSPEND transition", test_num);
            reset_dut();

            go_active = 1;
            @(posedge clk);
            #1;
            go_active = 0;
            go_suspend = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(SUSPEND);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: SUSPEND to ACTIVE transition", test_num);
            reset_dut();

            go_active = 1;
            @(posedge clk); #1;

            go_active = 0;
            go_suspend = 1;
            @(posedge clk); #1;

            go_suspend = 0;
            go_active = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(ACTIVE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Reset from SUSPEND back to IDLE", test_num);
            reset_dut();

            go_active = 1; @(posedge clk); #1;
            go_active = 0; go_suspend = 1; @(posedge clk); #1;

            reset = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(IDLE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Verify IDLE stability without go_active", test_num);
            reset_dut();
            go_suspend = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(IDLE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sata_controller Testbench");
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
        input [1:0] expected_state;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: state=%h",
                         state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h",
                         expected_state);
                $display("  Got:      state=%h",
                         state);
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
        $dumpvars(0,clk, go_active, go_suspend, reset, state);
    end

endmodule
