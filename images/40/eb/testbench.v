`timescale 1ns/1ps

module fan_speed_control_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] speed_input;
    wire [1:0] current_speed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fan_speed_control dut (
        .clk(clk),
        .speed_input(speed_input),
        .current_speed(current_speed)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            speed_input = 2'b00;

            @(posedge clk);
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Off (00) to Low (01)", test_num);
            reset_dut();
            speed_input = 2'b01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Off (00) to Medium (10)", test_num);
            reset_dut();
            speed_input = 2'b10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Off (00) to High (11)", test_num);
            reset_dut();
            speed_input = 2'b11;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: High (11) back to Off (00)", test_num);
            reset_dut();
            speed_input = 2'b11;
            @(posedge clk);
            #1;
            speed_input = 2'b00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Low (01) to Medium (10)", test_num);
            reset_dut();
            speed_input = 2'b01;
            @(posedge clk);
            #1;
            speed_input = 2'b10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Medium (10) to Low (01)", test_num);
            reset_dut();
            speed_input = 2'b10;
            @(posedge clk);
            #1;
            speed_input = 2'b01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Maintain Medium (10)", test_num);
            reset_dut();
            speed_input = 2'b10;
            @(posedge clk);
            #1;
            speed_input = 2'b10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fan_speed_control Testbench");
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
        input [1:0] expected_current_speed;
        begin
            if (expected_current_speed === (expected_current_speed ^ current_speed ^ expected_current_speed)) begin
                $display("PASS");
                $display("  Outputs: current_speed=%h",
                         current_speed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_speed=%h",
                         expected_current_speed);
                $display("  Got:      current_speed=%h",
                         current_speed);
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
        $dumpvars(0,clk, speed_input, current_speed);
    end

endmodule
