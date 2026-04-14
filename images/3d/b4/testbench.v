`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] control;
    reg [7:0] data_in;
    reg enable;
    wire [7:0] data_out;
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
        .enable(enable),
        .data_out(data_out),
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
        data_in = 8'h00;
        control = 3'b000;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Data transfer with enable HIGH", test_num);
        reset_dut();
        enable = 1;
        data_in = 8'hA5;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'hA5, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Data transfer with enable LOW", test_num);
        reset_dut();

        enable = 1;
        data_in = 8'h55;
        @(posedge clk);
        #1;

        enable = 0;
        data_in = 8'hFF;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h55, 8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Control 000 (All low)", test_num);
        reset_dut();
        control = 3'b000;
        #2;
        #1;

        check_outputs(8'h00, 8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Control 001 (Bit 0 high)", test_num);
        reset_dut();
        control = 3'b001;
        #2;
        #1;

        check_outputs(8'h00, 8'h01);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Control 010 (Bit 1 high)", test_num);
        reset_dut();
        control = 3'b010;
        #2;
        #1;

        check_outputs(8'h00, 8'h02);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Control 111 (Bit 6 high)", test_num);
        reset_dut();
        control = 3'b111;
        #2;
        #1;

        check_outputs(8'h00, 8'h40);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Combined Data and Control update", test_num);
        reset_dut();
        enable = 1;
        data_in = 8'h3C;
        control = 3'b011;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h3C, 8'h04);
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
        input [7:0] expected_data_out;
        input [7:0] expected_gpio_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_gpio_out === (expected_gpio_out ^ gpio_out ^ expected_gpio_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, gpio_out=%h",
                         data_out, gpio_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, gpio_out=%h",
                         expected_data_out, expected_gpio_out);
                $display("  Got:      data_out=%h, gpio_out=%h",
                         data_out, gpio_out);
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
        $dumpvars(0,clk, control, data_in, enable, data_out, gpio_out);
    end

endmodule
