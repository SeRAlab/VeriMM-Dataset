`timescale 1ns/1ps

module phase_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg input_a;
    reg input_b;
    wire output_phase;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_detector dut (
        .clk(clk),
        .input_a(input_a),
        .input_b(input_b),
        .output_phase(output_phase)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            input_a = 0;
            input_b = 0;

            repeat (2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Both signals High (In Phase)", test_num);
            @(negedge clk);
            input_a = 1;
            input_b = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Both signals Low (In Phase)", test_num);
            @(negedge clk);
            input_a = 0;
            input_b = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Input A High, Input B Low (Out of Phase)", test_num);
            @(negedge clk);
            input_a = 1;
            input_b = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Input A Low, Input B High (Out of Phase)", test_num);
            @(negedge clk);
            input_a = 0;
            input_b = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Simultaneous Rising Edge (In Phase)", test_num);
            @(negedge clk);
            input_a = 0;
            input_b = 0;
            @(posedge clk);
            @(negedge clk);
            input_a = 1;
            input_b = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test %0d: Input A toggles alone (Out of Phase)", test_num);
            @(negedge clk);
            input_a = 1;
            input_b = 1;
            @(posedge clk);
            @(negedge clk);
            input_a = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Test %0d: Out of Phase then returning to In Phase", test_num);
            @(negedge clk);
            input_a = 1;
            input_b = 0;
            @(posedge clk);
            @(negedge clk);
            input_b = 1;
            @(posedge clk);
            #2;
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
        $display("phase_detector Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_output_phase;
        begin
            if (expected_output_phase === (expected_output_phase ^ output_phase ^ expected_output_phase)) begin
                $display("PASS");
                $display("  Outputs: output_phase=%b",
                         output_phase);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_phase=%b",
                         expected_output_phase);
                $display("  Got:      output_phase=%b",
                         output_phase);
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
        $dumpvars(0,clk, input_a, input_b, output_phase);
    end

endmodule
