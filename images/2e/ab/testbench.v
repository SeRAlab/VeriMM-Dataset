`timescale 1ns/1ps

module nvme_controller_status_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cmd_completed;
    reg cmd_error;
    reg cmd_submitted;
    reg rst_n;
    wire [1:0] status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_controller_status dut (
        .clk(clk),
        .cmd_completed(cmd_completed),
        .cmd_error(cmd_error),
        .cmd_submitted(cmd_submitted),
        .rst_n(rst_n),
        .status(status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 1;
            cmd_submitted = 0;
            cmd_completed = 0;
            cmd_error = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying Reset State (IDLE)", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Verifying Command Submitted (IN PROGRESS)", test_num);
            reset_dut();
            @(posedge clk);
            cmd_submitted = 1;
            @(posedge clk);
            cmd_submitted = 0;
            repeat(1) @(posedge clk);

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verifying Command Completion (COMPLETED)", test_num);
            reset_dut();
            @(posedge clk);
            cmd_submitted = 1;
            @(posedge clk);
            cmd_submitted = 0;
            cmd_completed = 1;
            @(posedge clk);
            cmd_completed = 0;
            repeat(1) @(posedge clk);

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verifying Command Error (ERROR)", test_num);
            reset_dut();
            @(posedge clk);
            cmd_submitted = 1;
            @(posedge clk);
            cmd_submitted = 0;
            cmd_error = 1;
            @(posedge clk);
            cmd_error = 0;
            repeat(1) @(posedge clk);

            #1;


            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verifying New Submission after Completion", test_num);
            reset_dut();

            @(posedge clk);
            cmd_submitted = 1;
            @(posedge clk);
            cmd_submitted = 0;
            cmd_completed = 1;
            @(posedge clk);
            cmd_completed = 0;

            @(posedge clk);
            cmd_submitted = 1;
            @(posedge clk);
            cmd_submitted = 0;
            repeat(1) @(posedge clk);

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Verifying Immediate Error Handling", test_num);
            reset_dut();
            @(posedge clk);
            cmd_submitted = 1;
            cmd_error = 1;
            @(posedge clk);
            cmd_submitted = 0;
            cmd_error = 0;
            repeat(1) @(posedge clk);

            #1;


            check_outputs(2'b11);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nvme_controller_status Testbench");
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
        input [1:0] expected_status;
        begin
            if (expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: status=%h",
                         status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: status=%h",
                         expected_status);
                $display("  Got:      status=%h",
                         status);
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
        $dumpvars(0,clk, cmd_completed, cmd_error, cmd_submitted, rst_n, status);
    end

endmodule
