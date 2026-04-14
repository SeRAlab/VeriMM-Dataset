`timescale 1ns/1ps

module edge_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire posedge_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    edge_detector dut (
        .clk(clk),
        .posedge_out(posedge_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin


            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %03d: Immediate Edge Detection", test_num);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %03d: Pulse Duration Check (Falling Edge)", test_num);
            @(posedge clk);
            @(negedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %03d: Multi-Cycle Stability Check", test_num);
            repeat(5) @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %03d: Boundary Transition Check", test_num);
            @(posedge clk);
            repeat(1) @(posedge clk);
            #0.1;
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
        $display("edge_detector Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_posedge_out;
        begin
            if (expected_posedge_out === (expected_posedge_out ^ posedge_out ^ expected_posedge_out)) begin
                $display("PASS");
                $display("  Outputs: posedge_out=%b",
                         posedge_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: posedge_out=%b",
                         expected_posedge_out);
                $display("  Got:      posedge_out=%b",
                         posedge_out);
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
        $dumpvars(0,clk, posedge_out);
    end

endmodule
