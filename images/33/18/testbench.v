`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] gpio_data_in;
    reg mode;
    reg reset;
    wire [7:0] gpio_data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .gpio_data_in(gpio_data_in),
        .mode(mode),
        .reset(reset),
        .gpio_data_out(gpio_data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            mode = 0;
            gpio_data_in = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Read Mode basic check", test_num);
            reset_dut();

            mode = 0;
            gpio_data_in = 8'hA5;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write Mode hold check", test_num);
            reset_dut();


            mode = 0;
            gpio_data_in = 8'h5A;
            @(posedge clk);


            #1 mode = 1;
            gpio_data_in = 8'hFF;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Read to Write to Read transition", test_num);
            reset_dut();


            mode = 0;
            gpio_data_in = 8'h11;
            @(posedge clk);


            #1 mode = 1;
            gpio_data_in = 8'h22;
            @(posedge clk);


            #1 mode = 0;
            gpio_data_in = 8'h33;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h33);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Continuous Read updates", test_num);
            reset_dut();

            mode = 0;
            gpio_data_in = 8'hAA;
            @(posedge clk);
            #1 gpio_data_in = 8'hBB;
            @(posedge clk);
            #1 gpio_data_in = 8'hCC;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Extended Write Mode hold", test_num);
            reset_dut();


            mode = 0;
            gpio_data_in = 8'hF0;
            @(posedge clk);


            #1 mode = 1;
            @(posedge clk);


            #1 gpio_data_in = 8'h0F; @(posedge clk);
            #1 gpio_data_in = 8'h77; @(posedge clk);
            #1 gpio_data_in = 8'h88; @(posedge clk);
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
        input [7:0] expected_gpio_data_out;
        begin
            if (expected_gpio_data_out === (expected_gpio_data_out ^ gpio_data_out ^ expected_gpio_data_out)) begin
                $display("PASS");
                $display("  Outputs: gpio_data_out=%h",
                         gpio_data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gpio_data_out=%h",
                         expected_gpio_data_out);
                $display("  Got:      gpio_data_out=%h",
                         gpio_data_out);
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
        $dumpvars(0,clk, gpio_data_in, mode, reset, gpio_data_out);
    end

endmodule
