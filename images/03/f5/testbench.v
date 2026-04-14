`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [1:0] stage;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .rst(rst),
        .stage(stage),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            stage = FETCH;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Full pipeline sequence (F->D->E)", test_num);
            reset_dut();

            stage = FETCH;
            @(posedge clk);
            stage = DECODE;
            @(posedge clk);
            stage = EXECUTE;
            @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Incomplete sequence (F->D)", test_num);
            reset_dut();

            stage = FETCH;
            @(posedge clk);
            stage = DECODE;
            @(posedge clk);

            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Idle in Fetch stage", test_num);
            reset_dut();

            stage = FETCH;
            @(posedge clk);
            @(posedge clk);

            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Reset during Execute stage", test_num);
            reset_dut();

            stage = FETCH;
            @(posedge clk);
            stage = DECODE;
            @(posedge clk);
            stage = EXECUTE;


            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
            rst = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Start new instruction after completion", test_num);
            reset_dut();


            stage = FETCH; @(posedge clk);
            stage = DECODE; @(posedge clk);
            stage = EXECUTE; @(posedge clk);


            stage = FETCH;
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
        $display("instruction_pipeline Testbench");
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
        input expected_done;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: done=%b",
                         done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b",
                         expected_done);
                $display("  Got:      done=%b",
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
        $dumpvars(0,clk, rst, stage, done);
    end

endmodule
