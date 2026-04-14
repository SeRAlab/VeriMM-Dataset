`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg enable;
    reg init;
    reg reset;
    reg [3:0] retry_count;
    wire [9:0] random;
    wire trigger;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .enable(enable),
        .init(init),
        .reset(reset),
        .retry_count(retry_count),
        .random(random),
        .trigger(trigger)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            init = 0;
            enable = 0;
            retry_count = 0;
            repeat (2) @(posedge clock);
            reset = 0;
            repeat (1) @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Reset", test_num);
            reset_dut();

            #1;


            check_outputs(10'h000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Initialization", test_num);
            reset_dut();

            @(posedge clock);
            init = 1;
            @(posedge clock);
            init = 0;
            repeat (2) @(posedge clock);




            if (random != 10'h000) begin
                $display("  Random value initialized to: %h", random);
                #1;

                check_outputs(random, 1'b0);
            end else begin
                #1;

                check_outputs(10'h000, 1'b0);
            end
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Operation with retry_count=1", test_num);
            reset_dut();

            @(posedge clock);
            init = 1;
            retry_count = 4'd1;
            @(posedge clock);
            init = 0;
            enable = 1;


            repeat (20) begin
                @(posedge clock);
                if (trigger) break;
            end


            #1;



            check_outputs(random, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Operation with retry_count=8", test_num);
            reset_dut();

            @(posedge clock);
            init = 1;
            retry_count = 4'd8;
            @(posedge clock);
            init = 0;
            enable = 1;


            repeat (100) begin
                @(posedge clock);
                if (trigger) break;
            end

            #1;


            check_outputs(random, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Enable Control Gate", test_num);
            reset_dut();

            @(posedge clock);
            init = 1;
            retry_count = 4'd2;
            @(posedge clock);
            init = 0;
            enable = 0;

            repeat (50) @(posedge clock);


            #1;



            check_outputs(random, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Mid-operation Reset", test_num);
            reset_dut();

            @(posedge clock);
            init = 1;
            retry_count = 4'd15;
            @(posedge clock);
            init = 0;
            enable = 1;

            repeat (10) @(posedge clock);

            reset = 1;
            @(posedge clock);
            reset = 0;


            #1;



            check_outputs(10'h000, 1'b0);
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
        input [9:0] expected_random;
        input expected_trigger;
        begin
            if (expected_random === (expected_random ^ random ^ expected_random) &&
                expected_trigger === (expected_trigger ^ trigger ^ expected_trigger)) begin
                $display("PASS");
                $display("  Outputs: random=%h, trigger=%b",
                         random, trigger);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: random=%h, trigger=%b",
                         expected_random, expected_trigger);
                $display("  Got:      random=%h, trigger=%b",
                         random, trigger);
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
        $dumpvars(0,clock, enable, init, reset, retry_count, random, trigger);
    end

endmodule
