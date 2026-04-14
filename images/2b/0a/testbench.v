`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] ctrl;
    reg enable;
    reg rst;
    wire [1:0] gpio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .ctrl(ctrl),
        .enable(enable),
        .rst(rst),
        .gpio_out(gpio_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ctrl = 2'b00;
            enable = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable High, Ctrl 01", test_num);
            reset_dut();
            enable = 1;
            ctrl = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable High, Ctrl 11", test_num);
            reset_dut();
            enable = 1;
            ctrl = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Low, Ctrl 10 (Should hold 00)", test_num);
            reset_dut();
            enable = 0;
            ctrl = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable High then Low (Should hold previous value)", test_num);
            reset_dut();


            enable = 1;
            ctrl = 2'b11;
            @(posedge clk);
            #1;


            enable = 0;
            ctrl = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential updates 01 -> 10 -> 11", test_num);
            reset_dut();
            enable = 1;

            ctrl = 2'b01; @(posedge clk); #1;
            ctrl = 2'b10; @(posedge clk); #1;
            ctrl = 2'b11; @(posedge clk); #1;

            #1;


            check_outputs(2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Pulse Verification", test_num);
            reset_dut();


            enable = 1;
            ctrl = 2'b10;
            @(posedge clk);
            #1;


            enable = 0;
            ctrl = 2'b01;
            @(posedge clk);
            #1;


            enable = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Priority over Enable", test_num);
            reset_dut();

            enable = 1;
            ctrl = 2'b11;
            @(posedge clk);
            #1;


            rst = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00);
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
        input [1:0] expected_gpio_out;
        begin
            if (expected_gpio_out === (expected_gpio_out ^ gpio_out ^ expected_gpio_out)) begin
                $display("PASS");
                $display("  Outputs: gpio_out=%h",
                         gpio_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gpio_out=%h",
                         expected_gpio_out);
                $display("  Got:      gpio_out=%h",
                         gpio_out);
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
        $dumpvars(0,clk, ctrl, enable, rst, gpio_out);
    end

endmodule
