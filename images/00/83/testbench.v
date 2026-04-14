`timescale 1ns/1ps

module phase_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk_a;
    reg clk_b;
    reg reset;
    wire in_phase;
    wire lag;
    wire lead;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_detector dut (
        .clk_a(clk_a),
        .clk_b(clk_b),
        .reset(reset),
        .in_phase(in_phase),
        .lag(lag),
        .lead(lead)
    );

    // Clock generation (10ns period)
    initial begin
        clk_a = 0;
        forever #5 clk_a = ~clk_a;
    end

        task reset_dut;

        begin
            reset = 1;
            clk_b = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            $display("Test %0d: Initial Reset State", test_num);
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            repeat(5) begin
                @(posedge clk_a);
                #2 clk_b = 1;
                #5 clk_b = 0;
            end
            #10;
            $display("Test %0d: clk_a Leading clk_b", test_num);
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();



            repeat(5) begin
                @(negedge clk_a);
                #3 clk_b = 1;
                #5 clk_b = 0;
            end
            @(posedge clk_a);
            #10;
            $display("Test %0d: clk_a Lagging clk_b", test_num);
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            repeat(5) begin
                @(posedge clk_a);
                clk_b = 1;
                #5 clk_b = 0;
            end
            #10;
            $display("Test %0d: clk_a and clk_b In Phase", test_num);
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            repeat(3) begin
                @(posedge clk_a);
                #2 clk_b = 1;
                #5 clk_b = 0;
            end

            repeat(3) begin
                @(negedge clk_a);
                #3 clk_b = 1;
                #5 clk_b = 0;
            end
            @(posedge clk_a);
            #10;
            $display("Test %0d: Dynamic transition Lead -> Lag", test_num);
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            clk_b = 0;
            repeat(5) @(posedge clk_a);
            #10;
            $display("Test %0d: clk_b stuck low (Lead expected)", test_num);
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("phase_detector Testbench");
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
        input expected_in_phase;
        input expected_lag;
        input expected_lead;
        begin
            if (expected_in_phase === (expected_in_phase ^ in_phase ^ expected_in_phase) &&
                expected_lag === (expected_lag ^ lag ^ expected_lag) &&
                expected_lead === (expected_lead ^ lead ^ expected_lead)) begin
                $display("PASS");
                $display("  Outputs: in_phase=%b, lag=%b, lead=%b",
                         in_phase, lag, lead);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: in_phase=%b, lag=%b, lead=%b",
                         expected_in_phase, expected_lag, expected_lead);
                $display("  Got:      in_phase=%b, lag=%b, lead=%b",
                         in_phase, lag, lead);
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
        $dumpvars(0,clk_a, clk_b, reset, in_phase, lag, lead);
    end

endmodule
