`timescale 1ns/1ps

module sata_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cmd;
    reg rst;
    wire cmd_done;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sata_controller dut (
        .clk(clk),
        .cmd(cmd),
        .rst(rst),
        .cmd_done(cmd_done),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting the DUT...");
            rst = 1;
            cmd = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Functional Path", test_num);
            reset_dut();


            cmd = 1;
            @(posedge clk);
            #1;
            cmd = 0;


            @(posedge clk);
            #1;


            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 2'b11);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Behavior Check", test_num);
            reset_dut();


            #1;



            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Interrupted Command via Reset", test_num);
            reset_dut();


            cmd = 1;
            @(posedge clk);
            #1;
            cmd = 0;


            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Return to IDLE after completion", test_num);
            reset_dut();


            cmd = 1;
            @(posedge clk);
            #1;
            cmd = 0;


            repeat(3) @(posedge clk);
            #1;


            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: IDLE persistence", test_num);
            reset_dut();


            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sata_controller Testbench");
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
        input expected_cmd_done;
        input [1:0] expected_state;
        begin
            if (expected_cmd_done === (expected_cmd_done ^ cmd_done ^ expected_cmd_done) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: cmd_done=%b, state=%h",
                         cmd_done, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cmd_done=%b, state=%h",
                         expected_cmd_done, expected_state);
                $display("  Got:      cmd_done=%b, state=%h",
                         cmd_done, state);
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
        $dumpvars(0,clk, cmd, rst, cmd_done, state);
    end

endmodule
