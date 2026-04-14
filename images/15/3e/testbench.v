`timescale 1ns/1ps

module fan_speed_control_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    reg [2:0] temp;
    wire [1:0] speed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fan_speed_control dut (
        .clk(clk),
        .rst_n(rst_n),
        .temp(temp),
        .speed(speed)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            temp = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            temp = 3'd0;
            #1;

            check_outputs(SPEED_LOW);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            temp = 3'd4;
            #1;

            check_outputs(SPEED_MED);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            temp = 3'd7;
            #1;

            check_outputs(SPEED_HIGH);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            temp = 3'd1;
            @(posedge clk);
            temp = 3'd6;
            #1;

            check_outputs(SPEED_HIGH);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            temp = 3'd7;
            @(posedge clk);
            temp = 3'd3;
            #1;

            check_outputs(SPEED_MED);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            temp = 3'd5;
            @(posedge clk);

            #1;


            check_outputs(SPEED_MED);
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
        input [1:0] expected_speed;
        begin
            if (expected_speed === (expected_speed ^ speed ^ expected_speed)) begin
                $display("PASS");
                $display("  Outputs: speed=%h",
                         speed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: speed=%h",
                         expected_speed);
                $display("  Got:      speed=%h",
                         speed);
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
        $dumpvars(0,clk, rst_n, temp, speed);
    end

endmodule
