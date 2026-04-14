`timescale 1ns/1ps

module elevator_control_tb;

    // Testbench signals (sequential circuit)
    reg call;
    reg clk;
    reg resetn;
    wire moving;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    elevator_control dut (
        .call(call),
        .clk(clk),
        .resetn(resetn),
        .moving(moving)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            resetn = 0;
            call = 0;
            @(posedge clk);
            #1 resetn = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Call trigger movement", test_num);
            reset_dut();
            call = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: No call remains stationary", test_num);
            reset_dut();
            call = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Sustained call signal", test_num);
            reset_dut();
            call = 1;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Reset during movement", test_num);
            reset_dut();

            call = 1;
            @(posedge clk);
            #1;

            resetn = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("elevator_control Testbench");
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
        input expected_moving;
        begin
            if (expected_moving === (expected_moving ^ moving ^ expected_moving)) begin
                $display("PASS");
                $display("  Outputs: moving=%b",
                         moving);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: moving=%b",
                         expected_moving);
                $display("  Got:      moving=%b",
                         moving);
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
        $dumpvars(0,call, clk, resetn, moving);
    end

endmodule
