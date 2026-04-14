`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] config_reg;
    reg [4:0] gpio_data;
    reg rst_n;
    wire [4:0] gpio_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .config_reg(config_reg),
        .gpio_data(gpio_data),
        .rst_n(rst_n),
        .gpio_output(gpio_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            config_reg = 0;
            gpio_data = 0;
            #15;
            rst_n = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Post-Reset Verification", test_num);
            reset_dut();

            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Bits Enabled", test_num);
            reset_dut();
            config_reg = 5'b11111;
            gpio_data = 5'b10101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Partial Bits Enabled (Masking)", test_num);
            reset_dut();

            config_reg = 5'b10101;

            gpio_data = 5'b11111;
            @(posedge clk);
            #1;

            #1;


            check_outputs(5'b10101);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Bits Disabled", test_num);
            reset_dut();
            config_reg = 5'b00000;
            gpio_data = 5'b11111;
            @(posedge clk);
            #1;

            #1;


            check_outputs(5'b00000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Change with Constant Config", test_num);
            reset_dut();
            config_reg = 5'b01110;
            gpio_data = 5'b11111;
            @(posedge clk);

            gpio_data = 5'b10101;
            @(posedge clk);
            #1;

            #1;


            check_outputs(5'b00100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bit Pattern", test_num);
            reset_dut();
            config_reg = 5'b11011;
            gpio_data = 5'b01010;
            @(posedge clk);
            #1;

            #1;


            check_outputs(5'b01010);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Bit Verification", test_num);
            reset_dut();
            config_reg = 5'b10000;
            gpio_data = 5'b10000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b10000);
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
        input [4:0] expected_gpio_output;
        begin
            if (expected_gpio_output === (expected_gpio_output ^ gpio_output ^ expected_gpio_output)) begin
                $display("PASS");
                $display("  Outputs: gpio_output=%h",
                         gpio_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gpio_output=%h",
                         expected_gpio_output);
                $display("  Got:      gpio_output=%h",
                         gpio_output);
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
        $dumpvars(0,clk, config_reg, gpio_data, rst_n, gpio_output);
    end

endmodule
