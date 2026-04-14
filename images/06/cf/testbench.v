`timescale 1ns/1ps

module deadbeat_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] current_state;
    reg [3:0] desired_state;
    wire [3:0] control_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deadbeat_controller dut (
        .clk(clk),
        .current_state(current_state),
        .desired_state(desired_state),
        .control_signal(control_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            current_state = 4'b0000;
            desired_state = 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Same state (0000 -> 0000)", test_num);
            reset_dut();
            current_state = 4'b0000;
            desired_state = 4'b0000;

            @(posedge clk); #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: 1-bit change (0000 -> 0001)", test_num);
            reset_dut();
            current_state = 4'b0000;
            desired_state = 4'b0001;
            repeat(1) begin
                @(posedge clk); #1;
                current_state = control_signal;
            end
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: 2-bit change (0000 -> 0011)", test_num);
            reset_dut();
            current_state = 4'b0000;
            desired_state = 4'b0011;
            repeat(2) begin
                @(posedge clk); #1;
                current_state = control_signal;
            end
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: 4-bit change (0000 -> 1111)", test_num);
            reset_dut();
            current_state = 4'b0000;
            desired_state = 4'b1111;
            repeat(4) begin
                @(posedge clk); #1;
                current_state = control_signal;
            end
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: 4-bit change (1111 -> 0000)", test_num);
            reset_dut();
            current_state = 4'b1111;
            desired_state = 4'b0000;
            repeat(4) begin
                @(posedge clk); #1;
                current_state = control_signal;
            end
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Alternating bits (1010 -> 0101)", test_num);
            reset_dut();
            current_state = 4'b1010;
            desired_state = 4'b0101;
            repeat(4) begin
                @(posedge clk); #1;
                current_state = control_signal;
            end
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Middle bits (1001 -> 1111)", test_num);
            reset_dut();
            current_state = 4'b1001;
            desired_state = 4'b1111;
            repeat(2) begin
                @(posedge clk); #1;
                current_state = control_signal;
            end
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: High to Low (1000 -> 0001)", test_num);
            reset_dut();
            current_state = 4'b1000;
            desired_state = 4'b0001;
            repeat(2) begin
                @(posedge clk); #1;
                current_state = control_signal;
            end
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Transition (1100 -> 0110)", test_num);
            reset_dut();
            current_state = 4'b1100;
            desired_state = 4'b0110;
            repeat(2) begin
                @(posedge clk); #1;
                current_state = control_signal;
            end
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Stability (0011 -> 1100 + Extra Cycles)", test_num);
            reset_dut();
            current_state = 4'b0011;
            desired_state = 4'b1100;

            repeat(6) begin
                @(posedge clk); #1;
                current_state = control_signal;
            end
            #1;

            check_outputs(4'b1100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deadbeat_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_control_signal;
        begin
            if (expected_control_signal === (expected_control_signal ^ control_signal ^ expected_control_signal)) begin
                $display("PASS");
                $display("  Outputs: control_signal=%h",
                         control_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_signal=%h",
                         expected_control_signal);
                $display("  Got:      control_signal=%h",
                         control_signal);
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
        $dumpvars(0,clk, current_state, desired_state, control_signal);
    end

endmodule
