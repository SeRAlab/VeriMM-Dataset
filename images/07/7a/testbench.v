`timescale 1ns/1ps

module zero_crossing_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg signal_in;
    wire crossing_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    zero_crossing_detector dut (
        .clk(clk),
        .enable(enable),
        .signal_in(signal_in),
        .crossing_out(crossing_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            enable = 0;
            signal_in = 0;
            @(posedge clk);
            #1;
            $display("\nTest Case %0d:", test_num);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            enable = 1;
            signal_in = 0;
            @(posedge clk);
            signal_in = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            enable = 1;
            signal_in = 1;
            @(posedge clk);


            signal_in = 1;
            @(posedge clk);
            signal_in = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            enable = 0;
            signal_in = 0;
            @(posedge clk);
            signal_in = 1;
            @(posedge clk);
            signal_in = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            enable = 1;

            signal_in = 1; @(posedge clk);

            signal_in = 0; @(posedge clk);

            signal_in = 1; @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            enable = 1;
            signal_in = 1;
            @(posedge clk);
            enable = 0;
            signal_in = 0;
            @(posedge clk);
            signal_in = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            enable = 1;
            signal_in = 1;
            @(posedge clk);
            enable = 0;
            signal_in = 0;
            @(posedge clk);
            enable = 1;
            signal_in = 1;
            @(posedge clk);
            signal_in = 0;
            @(posedge clk);
            #1;
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
        $display("zero_crossing_detector Testbench");
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
        input expected_crossing_out;
        begin
            if (expected_crossing_out === (expected_crossing_out ^ crossing_out ^ expected_crossing_out)) begin
                $display("PASS");
                $display("  Outputs: crossing_out=%b",
                         crossing_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crossing_out=%b",
                         expected_crossing_out);
                $display("  Got:      crossing_out=%b",
                         crossing_out);
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
        $dumpvars(0,clk, enable, signal_in, crossing_out);
    end

endmodule
