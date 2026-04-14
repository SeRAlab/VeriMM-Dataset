`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg gpio_in;
    reg read_enable;
    reg write_enable;
    wire gpio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .gpio_in(gpio_in),
        .read_enable(read_enable),
        .write_enable(write_enable),
        .gpio_out(gpio_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            gpio_in = 0;
            read_enable = 0;
            write_enable = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Write 1, Read 1");
            reset_dut();


            gpio_in = 1;
            write_enable = 1;
            @(posedge clk);
            #1;
            write_enable = 0;


            read_enable = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Write 0, Read 0");
            reset_dut();


            gpio_in = 0;
            write_enable = 1;
            @(posedge clk);
            #1;
            write_enable = 0;


            read_enable = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Write 1, Read Disable");
            reset_dut();


            gpio_in = 1;
            write_enable = 1;
            @(posedge clk);
            #1;
            write_enable = 0;


            read_enable = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Data persistence / No Write when Enable Low");
            reset_dut();


            gpio_in = 1;
            write_enable = 1;
            @(posedge clk);
            #1;


            gpio_in = 0;
            write_enable = 0;
            @(posedge clk);
            #1;


            read_enable = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Overwrite previous value");
            reset_dut();


            gpio_in = 1;
            write_enable = 1;
            @(posedge clk);
            #1;


            gpio_in = 0;
            write_enable = 1;
            @(posedge clk);
            #1;
            write_enable = 0;


            read_enable = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Simultaneous Read and Write");
            reset_dut();


            gpio_in = 1;
            write_enable = 1;
            read_enable = 1;
            @(posedge clk);
            #1;




            #1;





            check_outputs(1'b1);
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
        input expected_gpio_out;
        begin
            if (expected_gpio_out === (expected_gpio_out ^ gpio_out ^ expected_gpio_out)) begin
                $display("PASS");
                $display("  Outputs: gpio_out=%b",
                         gpio_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gpio_out=%b",
                         expected_gpio_out);
                $display("  Got:      gpio_out=%b",
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
        $dumpvars(0,clk, gpio_in, read_enable, write_enable, gpio_out);
    end

endmodule
