`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] din;
    reg rdy;
    reg rst_n;
    reg we;
    wire [4:0] dout;
    wire [4:0] gpio_in;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .din(din),
        .rdy(rdy),
        .rst_n(rst_n),
        .we(we),
        .dout(dout),
        .gpio_in(gpio_in)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            din = 5'b0;
            we = 0;
            rdy = 0;
            @(posedge clk);
            #1;
            rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(5'h00, 5'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Write to Output Register", test_num);
            reset_dut();
            @(posedge clk);
            we = 1;
            din = 5'h1A;
            @(posedge clk);
            we = 0;
            din = 5'h00;
            #1;
            #1;

            check_outputs(5'h1A, 5'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Read into Input Register", test_num);
            reset_dut();
            @(posedge clk);
            rdy = 1;
            din = 5'h0F;
            @(posedge clk);
            rdy = 0;
            din = 5'h00;
            #1;
            #1;

            check_outputs(5'h00, 5'h0F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Simultaneous Write and Read", test_num);
            reset_dut();
            @(posedge clk);
            we = 1;
            rdy = 1;
            din = 5'h15;
            @(posedge clk);
            we = 0;
            rdy = 0;
            #1;
            #1;

            check_outputs(5'h15, 5'h15);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Persistence Check (we/rdy low)", test_num);
            reset_dut();

            @(posedge clk);
            we = 1;
            din = 5'h05;
            @(posedge clk);

            we = 0;
            rdy = 0;
            din = 5'h1F;
            @(posedge clk);
            #1;

            #1;


            check_outputs(5'h05, 5'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Reset during operation", test_num);
            reset_dut();
            @(posedge clk);
            we = 1;
            din = 5'h1F;
            @(posedge clk);
            #1;
            rst_n = 0;
            #1;
            #1;

            check_outputs(5'h00, 5'h00);
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
        input [4:0] expected_dout;
        input [4:0] expected_gpio_in;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_gpio_in === (expected_gpio_in ^ gpio_in ^ expected_gpio_in)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, gpio_in=%h",
                         dout, gpio_in);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, gpio_in=%h",
                         expected_dout, expected_gpio_in);
                $display("  Got:      dout=%h, gpio_in=%h",
                         dout, gpio_in);
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
        $dumpvars(0,clk, din, rdy, rst_n, we, dout, gpio_in);
    end

endmodule
