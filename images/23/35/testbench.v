`timescale 1ns/1ps

module light_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] control;
    wire [1:0] light_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    light_controller dut (
        .clk(clk),
        .control(control),
        .light_state(light_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            control = 2'b00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            control = 2'b00;
            @(posedge clk);
            #1;
            $display("Testcase 001: Initial State (OFF)");
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            control = 2'b01;
            @(posedge clk);
            #1;
            $display("Testcase 002: OFF to ON transition");
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            control = 2'b01;
            @(posedge clk);
            #1;
            control = 2'b01;
            @(posedge clk);
            #1;
            $display("Testcase 003: Toggle OFF -> ON -> OFF");
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            control = 2'b01;
            @(posedge clk);
            #1;
            control = 2'b10;
            @(posedge clk);
            #1;
            $display("Testcase 004: ON to BLINK transition");
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            control = 2'b01;
            @(posedge clk);
            #1;
            control = 2'b00;
            @(posedge clk);
            @(posedge clk);
            #1;
            $display("Testcase 005: Maintain ON state with control=0");
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            control = 2'b01;
            @(posedge clk);
            #1;
            control = 2'b10;
            @(posedge clk);
            #1;
            control = 2'b00;
            @(posedge clk);
            #1;
            $display("Testcase 006: Maintain BLINK state with control=0");
            #1;

            check_outputs(2'd2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("light_controller Testbench");
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
        input [1:0] expected_light_state;
        begin
            if (expected_light_state === (expected_light_state ^ light_state ^ expected_light_state)) begin
                $display("PASS");
                $display("  Outputs: light_state=%h",
                         light_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: light_state=%h",
                         expected_light_state);
                $display("  Got:      light_state=%h",
                         light_state);
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
        $dumpvars(0,clk, control, light_state);
    end

endmodule
