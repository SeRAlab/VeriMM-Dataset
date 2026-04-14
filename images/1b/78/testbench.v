`timescale 1ns/1ps

module sata_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] command;
    reg rst;
    wire ready;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sata_controller dut (
        .clk(clk),
        .command(command),
        .rst(rst),
        .ready(ready),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            command = 2'b00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Power-on Reset test", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Transition IDLE -> READ", test_num);
            reset_dut();
            command = 2'b01;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Transition IDLE -> WRITE", test_num);
            reset_dut();
            command = 2'b10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Return to IDLE from READ", test_num);
            reset_dut();
            command = 2'b01;
            @(posedge clk);
            #1;
            command = 2'b00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Return to IDLE from WRITE", test_num);
            reset_dut();
            command = 2'b10;
            @(posedge clk);
            #1;
            command = 2'b00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Transition READ -> WRITE", test_num);
            reset_dut();
            command = 2'b01;
            @(posedge clk);
            #1;
            command = 2'b10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Reset while in WRITE state", test_num);
            reset_dut();
            command = 2'b10;
            @(posedge clk);
            #1;
            rst = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 2'b00);
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
        input expected_ready;
        input [1:0] expected_state;
        begin
            if (expected_ready === (expected_ready ^ ready ^ expected_ready) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: ready=%b, state=%h",
                         ready, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ready=%b, state=%h",
                         expected_ready, expected_state);
                $display("  Got:      ready=%b, state=%h",
                         ready, state);
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
        $dumpvars(0,clk, command, rst, ready, state);
    end

endmodule
