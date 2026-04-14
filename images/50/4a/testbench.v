`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg globalreset;
    reg newresult;
    reg reset;
    reg [1:0] resultID;
    wire [1:0] done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .globalreset(globalreset),
        .newresult(newresult),
        .reset(reset),
        .resultID(resultID),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            globalreset = 1;
            reset = 1;
            newresult = 0;
            resultID = 2'b00;
            repeat (2) @(posedge clk);
            globalreset = 0;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Reset", test_num);
            reset_dut();
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Trigger ID 0", test_num);
            reset_dut();
            @(posedge clk);
            newresult = 1;
            resultID = 2'b00;
            @(posedge clk);
            newresult = 0;
            repeat (2) @(posedge clk);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Triggers ID 1", test_num);
            reset_dut();
            repeat (3) begin
                @(posedge clk);
                newresult = 1;
                resultID = 2'b01;
                @(posedge clk);
                newresult = 0;
            end
            repeat (2) @(posedge clk);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Result ID Rotation", test_num);
            reset_dut();
            @(posedge clk);
            newresult = 1; resultID = 2'b01; @(posedge clk);
            newresult = 1; resultID = 2'b10; @(posedge clk);
            newresult = 1; resultID = 2'b11; @(posedge clk);
            newresult = 0;
            repeat (4) @(posedge clk);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-operation Reset", test_num);
            reset_dut();
            @(posedge clk);
            newresult = 1;
            resultID = 2'b11;
            repeat (3) @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            repeat (2) @(posedge clk);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Global Reset Priority", test_num);
            reset_dut();
            @(posedge clk);
            newresult = 1;
            resultID = 2'b01;
            globalreset = 1;
            repeat (2) @(posedge clk);
            globalreset = 0;
            newresult = 0;
            #1;

            check_outputs(2'b00);
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
        input [1:0] expected_done;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: done=%h",
                         done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%h",
                         expected_done);
                $display("  Got:      done=%h",
                         done);
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
        $dumpvars(0,clk, globalreset, newresult, reset, resultID, done);
    end

endmodule
