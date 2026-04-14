`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] GPIO_OUT;
    reg clk;
    reg reset;
    reg write_enable;
    wire [3:0] GPIO_IN;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .GPIO_OUT(GPIO_OUT),
        .clk(clk),
        .reset(reset),
        .write_enable(write_enable),
        .GPIO_IN(GPIO_IN)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            write_enable = 0;
            GPIO_OUT = 4'b0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Test 001: Checking Reset State...");
            reset_dut();
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Test 002: Checking Inactive Write Enable...");
            reset_dut();
            GPIO_OUT = 4'b1111;
            write_enable = 0;
            @(posedge clk);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase003;

        begin
            $display("Test 003: Checking Single Bit Toggle...");
            reset_dut();
            GPIO_OUT = 4'b0001;
            write_enable = 1;
            @(posedge clk);
            #1 write_enable = 0;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase004;

        begin
            $display("Test 004: Checking All-Bit Toggle...");
            reset_dut();
            GPIO_OUT = 4'b1111;
            write_enable = 1;
            @(posedge clk);
            #1 write_enable = 0;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase005;

        begin
            $display("Test 005: Checking Double Toggle (Toggle back to 0)...");
            reset_dut();
            write_enable = 1;
            GPIO_OUT = 4'b1010;
            @(posedge clk);
            GPIO_OUT = 4'b1010;
            @(posedge clk);
            #1 write_enable = 0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            $display("Test 006: Checking Sequential Partial Toggles...");
            reset_dut();
            write_enable = 1;
            GPIO_OUT = 4'b1100;
            @(posedge clk);
            GPIO_OUT = 4'b0110;
            @(posedge clk);
            #1 write_enable = 0;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase007;

        begin
            $display("Test 007: Checking Data Hold when Write Enable drops...");
            reset_dut();
            write_enable = 1;
            GPIO_OUT = 4'b0101;
            @(posedge clk);
            write_enable = 0;
            GPIO_OUT = 4'b1111;
            @(posedge clk);
            #1;

            check_outputs(4'b0101);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gpio_controller Testbench");
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
        input [3:0] expected_GPIO_IN;
        begin
            if (expected_GPIO_IN === (expected_GPIO_IN ^ GPIO_IN ^ expected_GPIO_IN)) begin
                $display("PASS");
                $display("  Outputs: GPIO_IN=%h",
                         GPIO_IN);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GPIO_IN=%h",
                         expected_GPIO_IN);
                $display("  Got:      GPIO_IN=%h",
                         GPIO_IN);
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
        $dumpvars(0,GPIO_OUT, clk, reset, write_enable, GPIO_IN);
    end

endmodule
