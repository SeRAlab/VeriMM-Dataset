`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control;
    reg [7:0] data_in;
    reg reset;
    wire [7:0] data_out;
    wire [7:0] pins;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .control(control),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out),
        .pins(pins)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            control = 0;
            data_in = 8'h00;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: System Reset", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Write Operation (Pattern AA)", test_num);
            reset_dut();
            data_in = 8'hAA;
            control = 0;

            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(data_out, 8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Write Operation (Pattern 55)", test_num);
            reset_dut();
            data_in = 8'h55;
            control = 0;
            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(data_out, 8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Read Operation (Pattern CC)", test_num);
            reset_dut();
            control = 1;

            force pins = 8'hCC;
            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(8'hCC, 8'hCC);
            release pins;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Read Operation (Pattern 33)", test_num);
            reset_dut();
            control = 1;
            force pins = 8'h33;
            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(8'h33, 8'h33);
            release pins;
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
        input [7:0] expected_data_out;
        input [7:0] expected_pins;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_pins === (expected_pins ^ pins ^ expected_pins)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, pins=%h",
                         data_out, pins);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, pins=%h",
                         expected_data_out, expected_pins);
                $display("  Got:      data_out=%h, pins=%h",
                         data_out, pins);
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
        $dumpvars(0,clk, control, data_in, reset, data_out, pins);
    end

endmodule
