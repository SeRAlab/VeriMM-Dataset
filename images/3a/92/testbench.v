`timescale 1ns/1ps

module fan_speed_control_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] TEMP;
    reg clk;
    reg rst;
    wire [2:0] FAN_SPEED;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fan_speed_control dut (
        .TEMP(TEMP),
        .clk(clk),
        .rst(rst),
        .FAN_SPEED(FAN_SPEED)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            TEMP = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: TEMP = 2 (Expect OFF - 000)", test_num);
            reset_dut();
            TEMP = 4'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: TEMP = 6 (Expect LOW - 001)", test_num);
            reset_dut();
            TEMP = 4'd6;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: TEMP = 9 (Expect MEDIUM - 010)", test_num);
            reset_dut();
            TEMP = 4'd9;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: TEMP = 14 (Expect HIGH - 011)", test_num);
            reset_dut();
            TEMP = 4'd14;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: TEMP = 3 (Expect OFF - 000)", test_num);
            reset_dut();
            TEMP = 4'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: TEMP = 4 (Expect LOW - 001)", test_num);
            reset_dut();
            TEMP = 4'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: TEMP = 7 (Expect LOW - 001)", test_num);
            reset_dut();
            TEMP = 4'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: TEMP = 8 (Expect MEDIUM - 010)", test_num);
            reset_dut();
            TEMP = 4'd8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: TEMP = 11 (Expect MEDIUM - 010)", test_num);
            reset_dut();
            TEMP = 4'd11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: TEMP = 12 (Expect HIGH - 011)", test_num);
            reset_dut();
            TEMP = 4'd12;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: TEMP = 15 (Expect HIGH - 011)", test_num);
            reset_dut();
            TEMP = 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test %0d: RST functionality with TEMP=15 (Expect OFF - 000)", test_num);
            reset_dut();
            TEMP = 4'd15;
            @(posedge clk);
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b000);
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
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input [2:0] expected_FAN_SPEED;
        begin
            if (expected_FAN_SPEED === (expected_FAN_SPEED ^ FAN_SPEED ^ expected_FAN_SPEED)) begin
                $display("PASS");
                $display("  Outputs: FAN_SPEED=%h",
                         FAN_SPEED);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: FAN_SPEED=%h",
                         expected_FAN_SPEED);
                $display("  Got:      FAN_SPEED=%h",
                         FAN_SPEED);
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
        $dumpvars(0,TEMP, clk, rst, FAN_SPEED);
    end

endmodule
