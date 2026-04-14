`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control;
    reg [7:0] data_in;
    reg rst;
    wire [7:0] gpio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .control(control),
        .data_in(data_in),
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
            control = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Checking Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Write 8'hAA with control high", test_num);
            reset_dut();
            control = 1;
            data_in = 8'hAA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Hold state (control low) while data_in changes", test_num);
            reset_dut();


            control = 1;
            data_in = 8'h55;
            @(posedge clk);


            #1;
            control = 0;
            data_in = 8'hZZ;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Write All-Ones (8'hFF)", test_num);
            reset_dut();
            control = 1;
            data_in = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Successive writes check", test_num);
            reset_dut();

            control = 1;
            data_in = 8'h12;
            @(posedge clk);

            #1 data_in = 8'h34;
            @(posedge clk);

            #1 data_in = 8'h56;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h56);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Toggle control signal between writes", test_num);
            reset_dut();


            control = 1;
            data_in = 8'h0F;
            @(posedge clk);


            #1;
            control = 0;
            data_in = 8'hF0;
            @(posedge clk);


            #1;
            control = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'hF0);
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
        input [7:0] expected_gpio_out;
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
        $dumpvars(0,clk, control, data_in, rst, gpio_out);
    end

endmodule
