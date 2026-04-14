`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] current_value;
    reg [31:0] learning_rate;
    reg rst;
    wire [31:0] new_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .clk(clk),
        .current_value(current_value),
        .learning_rate(learning_rate),
        .rst(rst),
        .new_value(new_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            current_value = 0;
            learning_rate = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Subtraction (100 - 10)", test_num);
            reset_dut();
            current_value = 32'd100;
            learning_rate = 32'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd90);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction resulting in zero (50 - 50)", test_num);
            reset_dut();
            current_value = 32'd50;
            learning_rate = 32'd50;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Underflow (0 - 1)", test_num);
            reset_dut();
            current_value = 32'd0;
            learning_rate = 32'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero learning rate (1000 - 0)", test_num);
            reset_dut();
            current_value = 32'd1000;
            learning_rate = 32'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd1000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large values (0xFFFFFFFF - 0x1)", test_num);
            reset_dut();
            current_value = 32'hFFFFFFFF;
            learning_rate = 32'h00000001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Specific hex value subtraction", test_num);
            reset_dut();
            current_value = 32'h12345678;
            learning_rate = 32'h00005678;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12340000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum learning rate (0 - 0xFFFFFFFF)", test_num);
            reset_dut();
            current_value = 32'd0;
            learning_rate = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gradient_descent Testbench");
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
        input [31:0] expected_new_value;
        begin
            if (expected_new_value === (expected_new_value ^ new_value ^ expected_new_value)) begin
                $display("PASS");
                $display("  Outputs: new_value=%h",
                         new_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_value=%h",
                         expected_new_value);
                $display("  Got:      new_value=%h",
                         new_value);
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
        $dumpvars(0,clk, current_value, learning_rate, rst, new_value);
    end

endmodule
