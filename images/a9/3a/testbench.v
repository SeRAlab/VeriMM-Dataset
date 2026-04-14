`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg doWork;
    reg pipelineReady;
    reg scheduleTask;
    reg scryptResultInputAvailable;
    reg [2:0] workCounter;
    wire decreasePrepare;
    wire [7:0] preparing;
    wire scryptResultAvailable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .doWork(doWork),
        .pipelineReady(pipelineReady),
        .scheduleTask(scheduleTask),
        .scryptResultInputAvailable(scryptResultInputAvailable),
        .workCounter(workCounter),
        .decreasePrepare(decreasePrepare),
        .preparing(preparing),
        .scryptResultAvailable(scryptResultAvailable)
    );
    task testcase001;

    begin
        test_num = 1;
        pipelineReady = 0;
        scheduleTask = 0;
        workCounter = 3'b000;
        scryptResultInputAvailable = 0;
        doWork = 0;
        #10;
        #1;

        check_outputs(1'b0, 8'h00, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        pipelineReady = 1;
        scheduleTask = 1;
        workCounter = 3'b011;
        scryptResultInputAvailable = 0;
        doWork = 0;
        #10;

        #1;


        check_outputs(1'b0, 8'h01, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;

        pipelineReady = 1;
        scheduleTask = 1;
        workCounter = 3'b011;
        scryptResultInputAvailable = 0;
        doWork = 1;
        #10;

        #1;


        check_outputs(1'b0, 8'h01, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        pipelineReady = 0;
        scheduleTask = 0;
        workCounter = 3'b000;
        scryptResultInputAvailable = 1;
        doWork = 0;
        #10;

        #1;


        check_outputs(1'b1, 8'h00, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        pipelineReady = 1;
        scheduleTask = 1;
        workCounter = 3'b010;
        scryptResultInputAvailable = 0;
        doWork = 0;
        #10;

        #1;


        check_outputs(1'b0, 8'h00, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        pipelineReady = 1;
        scheduleTask = 0;
        workCounter = 3'b000;
        scryptResultInputAvailable = 1;
        doWork = 0;
        #10;

        #1;


        check_outputs(1'b1, 8'h00, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;

        pipelineReady = 1; scheduleTask = 1; workCounter = 3'b011;
        doWork = 0; scryptResultInputAvailable = 0;
        #10;
        #10;

        #1;


        check_outputs(1'b0, 8'h02, 1'b1);
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
        input expected_decreasePrepare;
        input [7:0] expected_preparing;
        input expected_scryptResultAvailable;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_decreasePrepare === (expected_decreasePrepare ^ decreasePrepare ^ expected_decreasePrepare) &&
                expected_preparing === (expected_preparing ^ preparing ^ expected_preparing) &&
                expected_scryptResultAvailable === (expected_scryptResultAvailable ^ scryptResultAvailable ^ expected_scryptResultAvailable)) begin
                $display("PASS");
                $display("  Outputs: decreasePrepare=%b, preparing=%h, scryptResultAvailable=%b",
                         decreasePrepare, preparing, scryptResultAvailable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decreasePrepare=%b, preparing=%h, scryptResultAvailable=%b",
                         expected_decreasePrepare, expected_preparing, expected_scryptResultAvailable);
                $display("  Got:      decreasePrepare=%b, preparing=%h, scryptResultAvailable=%b",
                         decreasePrepare, preparing, scryptResultAvailable);
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

endmodule
