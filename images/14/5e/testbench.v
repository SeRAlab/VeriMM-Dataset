`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg enable;
    reg [7:0] pin_config;
    reg read_enable;
    reg rst;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .pin_config(pin_config),
        .read_enable(read_enable),
        .rst(rst),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            data_in = 8'h00;
            pin_config = 8'h00;
            read_enable = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();
            read_enable = 1;
            enable = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: All Pins Output Mode (Write 0xAA)", test_num);
            reset_dut();
            enable = 1;
            pin_config = 8'hFF;
            data_in = 8'hAA;
            read_enable = 0;
            @(posedge clk);
            #1 read_enable = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: All Pins Output Mode (Write 0x55)", test_num);
            reset_dut();
            enable = 1;
            pin_config = 8'hFF;
            data_in = 8'h55;
            read_enable = 1;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Enable signal disabled", test_num);
            reset_dut();
            enable = 0;
            pin_config = 8'hFF;
            data_in = 8'hFF;
            read_enable = 1;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Read Enable disabled", test_num);
            reset_dut();
            enable = 1;
            pin_config = 8'hFF;
            data_in = 8'hA5;
            read_enable = 0;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Mixed Configuration (0xF0)", test_num);
            reset_dut();
            enable = 1;
            pin_config = 8'h0F;
            data_in = 8'hFF;
            read_enable = 1;
            @(posedge clk);
            @(posedge clk);


            #1 #1;
 check_outputs(8'h0F);
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, enable, pin_config, read_enable, rst, data_out);
    end

endmodule
