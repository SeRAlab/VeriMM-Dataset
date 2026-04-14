`timescale 1ns/1ps

module washing_machine_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg start_washing;
    reg wash_done;
    wire washing;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    washing_machine dut (
        .areset(areset),
        .clk(clk),
        .start_washing(start_washing),
        .wash_done(wash_done),
        .washing(washing)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            start_washing = 0;
            wash_done = 0;
            #15;
            areset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Check Initial State (Idle)", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Transition Idle to Washing", test_num);
            reset_dut();
            @(negedge clk);
            start_washing = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Transition Washing back to Idle", test_num);
            reset_dut();

            @(negedge clk) start_washing = 1;
            @(posedge clk);

            @(negedge clk) start_washing = 0; wash_done = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Maintain Washing State", test_num);
            reset_dut();
            @(negedge clk) start_washing = 1;
            @(posedge clk);
            @(negedge clk) start_washing = 0; wash_done = 0;
            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Maintain Idle State", test_num);
            reset_dut();
            @(negedge clk) start_washing = 0; wash_done = 0;
            repeat(2) @(posedge clk);
            #2;
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
        $display("washing_machine Testbench");
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
        input expected_washing;
        begin
            if (expected_washing === (expected_washing ^ washing ^ expected_washing)) begin
                $display("PASS");
                $display("  Outputs: washing=%b",
                         washing);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: washing=%b",
                         expected_washing);
                $display("  Got:      washing=%b",
                         washing);
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
        $dumpvars(0,areset, clk, start_washing, wash_done, washing);
    end

endmodule
