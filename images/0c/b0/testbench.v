`timescale 1ns/1ps

module fan_speed_control_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [3:0] temp;
    wire [1:0] fan_speed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fan_speed_control dut (
        .clk(clk),
        .rst(rst),
        .temp(temp),
        .fan_speed(fan_speed)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            temp = 4'b0000;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing Minimum Temperature (0000) for LOW speed", test_num);
            reset_dut();
            temp = 4'b0000;
            @(posedge clk);
            #2 #1;
 check_outputs(SPEED_LOW);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing Upper Boundary of LOW range (0110)", test_num);
            reset_dut();
            temp = 4'b0110;
            @(posedge clk);
            #2 #1;
 check_outputs(SPEED_LOW);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing Lower Boundary of MEDIUM range (0111)", test_num);
            reset_dut();
            temp = 4'b0111;
            @(posedge clk);
            #2 #1;
 check_outputs(SPEED_MEDIUM);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing Upper Boundary of MEDIUM range (1100)", test_num);
            reset_dut();
            temp = 4'b1100;
            @(posedge clk);
            #2 #1;
 check_outputs(SPEED_MEDIUM);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing Lower Boundary of HIGH range (1101)", test_num);
            reset_dut();
            temp = 4'b1101;
            @(posedge clk);
            #2 #1;
 check_outputs(SPEED_HIGH);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing Maximum Temperature (1111) for HIGH speed", test_num);
            reset_dut();
            temp = 4'b1111;
            @(posedge clk);
            #2 #1;
 check_outputs(SPEED_HIGH);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing Mid-range LOW value (0011)", test_num);
            reset_dut();
            temp = 4'b0011;
            @(posedge clk);
            #2 #1;
 check_outputs(SPEED_LOW);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing transition from Reset to HIGH range (1110)", test_num);
            reset_dut();
            temp = 4'b1110;
            @(posedge clk);
            #2 #1;
 check_outputs(SPEED_HIGH);
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
        input [1:0] expected_fan_speed;
        begin
            if (expected_fan_speed === (expected_fan_speed ^ fan_speed ^ expected_fan_speed)) begin
                $display("PASS");
                $display("  Outputs: fan_speed=%h",
                         fan_speed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fan_speed=%h",
                         expected_fan_speed);
                $display("  Got:      fan_speed=%h",
                         fan_speed);
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
        $dumpvars(0,clk, rst, temp, fan_speed);
    end

endmodule
