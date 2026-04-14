`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [4:0] gpio_in;
    wire [4:0] gpio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .enable(enable),
        .gpio_in(gpio_in),
        .gpio_out(gpio_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            gpio_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running Testcase %0d: Basic write (Enable=1, In=5'h15)", test_num);
            enable = 1;
            gpio_in = 5'h15;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'h15);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase %0d: Disabled update (Enable=0, In=5'h0A)", test_num);


            enable = 1;
            gpio_in = 5'h01;
            @(posedge clk);
            #1;


            enable = 0;
            gpio_in = 5'h0A;
            @(posedge clk);
            #2;





            if (gpio_out === 5'h0A) begin
                $display("FAIL: Output updated while enable was low");
                fail_count = fail_count + 1;
            end else begin
                $display("PASS: Output did not mirror input while disabled");
                pass_count = pass_count + 1;
            end
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase %0d: Boundary value (All Ones)", test_num);
            enable = 1;
            gpio_in = 5'h1F;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running Testcase %0d: Boundary value (All Zeros)", test_num);
            enable = 1;
            gpio_in = 5'h00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Running Testcase %0d: Clock synchronization check", test_num);
            enable = 1;
            gpio_in = 5'h10;
            #2;


            if (gpio_out === 5'h10) begin
                 $display("FAIL: Output updated before clock edge");
                 fail_count = fail_count + 1;
            end else begin
                @(posedge clk);
                #2;
                #1;

                check_outputs(5'h10);
            end
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Running Testcase %0d: Alternating bits (5'h0A)", test_num);
            enable = 1;
            gpio_in = 5'h0A;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'h0A);
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
        $dumpvars(0,clk, enable, gpio_in, gpio_out);
    end

endmodule
