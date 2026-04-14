`timescale 1ns/1ps

module traffic_light_controller_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    wire [1:0] ew_light;
    wire [1:0] ns_light;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    traffic_light_controller dut (
        .areset(areset),
        .clk(clk),
        .ew_light(ew_light),
        .ns_light(ns_light)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            #20;
            areset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %03d: Asynchronous Reset - All lights Red", test_num);
            areset = 1;
            #15;

            #1;


            check_outputs(2'd0, 2'd0);
            areset = 0;
            #5;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %03d: Initial state NS Green / EW Red", test_num);
            reset_dut();

            #1;


            check_outputs(2'd0, 2'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %03d: Transition to NS Yellow after 10 NS Green cycles", test_num);
            reset_dut();

            repeat(10) @(posedge clk);
            #2;
            #1;

            check_outputs(2'd0, 2'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %03d: Transition to EW Green after NS Yellow", test_num);
            reset_dut();

            repeat(13) @(posedge clk);
            #2;
            #1;

            check_outputs(2'd2, 2'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %03d: Transition to EW Yellow after EW Green", test_num);
            reset_dut();

            repeat(23) @(posedge clk);
            #2;
            #1;

            check_outputs(2'd1, 2'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %03d: Cycle completion and return to NS Green", test_num);
            reset_dut();

            repeat(26) @(posedge clk);
            #2;
            #1;

            check_outputs(2'd0, 2'd2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("traffic_light_controller Testbench");
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
        input [1:0] expected_ew_light;
        input [1:0] expected_ns_light;
        begin
            if (expected_ew_light === (expected_ew_light ^ ew_light ^ expected_ew_light) &&
                expected_ns_light === (expected_ns_light ^ ns_light ^ expected_ns_light)) begin
                $display("PASS");
                $display("  Outputs: ew_light=%h, ns_light=%h",
                         ew_light, ns_light);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ew_light=%h, ns_light=%h",
                         expected_ew_light, expected_ns_light);
                $display("  Got:      ew_light=%h, ns_light=%h",
                         ew_light, ns_light);
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
        $dumpvars(0,areset, clk, ew_light, ns_light);
    end

endmodule
