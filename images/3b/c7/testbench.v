`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] gpio_in;
    reg wr_en;
    wire [4:0] gpio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .gpio_in(gpio_in),
        .wr_en(wr_en),
        .gpio_out(gpio_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wr_en = 0;
            gpio_in = 5'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write", test_num);
            reset_dut();

            gpio_in = 5'h1A;
            wr_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(5'h1A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Low (Hold)", test_num);
            reset_dut();


            gpio_in = 5'h0F;
            wr_en = 1;
            @(posedge clk);
            #1;


            gpio_in = 5'h00;
            wr_en = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(5'h0F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write All Ones", test_num);
            reset_dut();

            gpio_in = 5'h1F;
            wr_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(5'h1F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write All Zeros", test_num);
            reset_dut();


            gpio_in = 5'h15;
            wr_en = 1;
            @(posedge clk);
            #1;


            gpio_in = 5'h00;
            wr_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(5'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Cycles Hold", test_num);
            reset_dut();


            gpio_in = 5'h05;
            wr_en = 1;
            @(posedge clk);
            #1;


            wr_en = 0;
            gpio_in = 5'h11; @(posedge clk);
            gpio_in = 5'h12; @(posedge clk);
            gpio_in = 5'h13; @(posedge clk);
            #1;

            #1;


            check_outputs(5'h05);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Writes", test_num);
            reset_dut();

            wr_en = 1;
            gpio_in = 5'h01; @(posedge clk);
            #1;
            gpio_in = 5'h02; @(posedge clk);
            #1;
            gpio_in = 5'h04; @(posedge clk);
            #1;
            gpio_in = 5'h08; @(posedge clk);
            #1;

            #1;


            check_outputs(5'h08);
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
        input [4:0] expected_gpio_out;
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
        $dumpvars(0,clk, gpio_in, wr_en, gpio_out);
    end

endmodule
