`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg done_rinse;
    reg done_spin;
    reg done_wash;
    reg start;
    wire running;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .clk(clk),
        .done_rinse(done_rinse),
        .done_spin(done_spin),
        .done_wash(done_wash),
        .start(start),
        .running(running)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            start = 0;
            done_wash = 0;
            done_rinse = 0;
            done_spin = 0;
            #12;
            areset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial Idle State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition to Wash State", test_num);
            reset_dut();
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Cycle (Wash->Rinse->Spin->Idle)", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            done_wash = 1;
            @(posedge clk);
            done_wash = 0;
            done_rinse = 1;
            @(posedge clk);
            done_rinse = 0;
            done_spin = 1;
            @(posedge clk);
            done_spin = 0;

            #2;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hold in Rinse state", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            done_wash = 1;
            @(posedge clk);
            done_wash = 0;


            repeat(5) @(posedge clk);

            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Async Reset during Spin", test_num);
            reset_dut();


            @(posedge clk) start = 1;
            @(posedge clk) begin start = 0; done_wash = 1; end
            @(posedge clk) begin done_wash = 0; done_rinse = 1; end
            @(posedge clk) begin done_rinse = 0; end


            #3 areset = 1;
            #5;


            #1;



            check_outputs(1'b0);
            areset = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Start bit ignored during Wash", test_num);
            reset_dut();

            @(posedge clk) start = 1;
            @(posedge clk) start = 1;


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
        input expected_running;
        begin
            if (expected_running === (expected_running ^ running ^ expected_running)) begin
                $display("PASS");
                $display("  Outputs: running=%b",
                         running);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: running=%b",
                         expected_running);
                $display("  Got:      running=%b",
                         running);
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
        $dumpvars(0,areset, clk, done_rinse, done_spin, done_wash, start, running);
    end

endmodule
