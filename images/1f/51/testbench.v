`timescale 1ns/1ps

module nvme_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] command_type;
    reg reset;
    wire command_processed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_controller dut (
        .clk(clk),
        .command_type(command_type),
        .reset(reset),
        .command_processed(command_processed)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        command_type = 2'b00;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Initial Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: READ Command Processing", test_num);
        reset_dut();
        command_type = 2'b01;
        @(posedge clk);
        #1;
        command_type = 2'b00;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: WRITE Command Processing", test_num);
        reset_dut();
        command_type = 2'b10;
        @(posedge clk);
        #1;
        command_type = 2'b00;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Idle State (No Command)", test_num);
        reset_dut();
        command_type = 2'b00;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reserved Command Type", test_num);
        reset_dut();
        command_type = 2'b11;
        @(posedge clk);
        #1;
        command_type = 2'b00;
        repeat(2) @(posedge clk);


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
        $display("nvme_controller Testbench");
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
        input expected_command_processed;
        begin
            if (expected_command_processed === (expected_command_processed ^ command_processed ^ expected_command_processed)) begin
                $display("PASS");
                $display("  Outputs: command_processed=%b",
                         command_processed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: command_processed=%b",
                         expected_command_processed);
                $display("  Got:      command_processed=%b",
                         command_processed);
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
        $dumpvars(0,clk, command_type, reset, command_processed);
    end

endmodule
