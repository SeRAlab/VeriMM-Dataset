`timescale 1ns/1ps

module position_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg direction;
    reg reset;
    wire [3:0] position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    position_encoder dut (
        .clk(clk),
        .direction(direction),
        .reset(reset),
        .position(position)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            direction = 0;
            @(posedge clk);
            #1 reset = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Forward movement from 0 to 5", test_num);
            reset_dut();
            direction = 1;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(4'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Backward movement (0 to 15 wrap)", test_num);
            reset_dut();
            direction = 0;
            repeat(1) @(posedge clk);
            #1 #1;
 check_outputs(4'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Forward wrap-around (15 to 0)", test_num);
            reset_dut();
            direction = 1;
            repeat(17) @(posedge clk);
            #1 #1;
 check_outputs(4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Mixed forward and backward movements", test_num);
            reset_dut();
            direction = 1; repeat(10) @(posedge clk);
            direction = 0; repeat(4) @(posedge clk);
            #1 #1;
 check_outputs(4'd6);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Extensive backward movement with multiple wraps", test_num);
            reset_dut();
            direction = 0;
            repeat(20) @(posedge clk);
            #1 #1;
 check_outputs(4'd12);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Reset during operation", test_num);
            reset_dut();
            direction = 1;
            repeat(8) @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            #1 #1;
 check_outputs(4'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("position_encoder Testbench");
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
        input [3:0] expected_position;
        begin
            if (expected_position === (expected_position ^ position ^ expected_position)) begin
                $display("PASS");
                $display("  Outputs: position=%h",
                         position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: position=%h",
                         expected_position);
                $display("  Got:      position=%h",
                         position);
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
        $dumpvars(0,clk, direction, reset, position);
    end

endmodule
