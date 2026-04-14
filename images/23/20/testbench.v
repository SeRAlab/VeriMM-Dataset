`timescale 1ns/1ps

module GPIO_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] command;
    reg [3:0] input_pin;
    reg [3:0] output_data;
    reg reset;
    wire [3:0] output_pin;
    wire [3:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    GPIO_Controller dut (
        .clk(clk),
        .command(command),
        .input_pin(input_pin),
        .output_data(output_data),
        .reset(reset),
        .output_pin(output_pin),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            command = 2'b00;
            input_pin = 4'h0;
            output_data = 4'h0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Power-on Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write Output pins (0xA)", test_num);
            reset_dut();

            command = 2'b10;
            output_data = 4'hA;
            @(posedge clk);
            #1 command = 2'b00;
            @(posedge clk);

            #1;


            check_outputs(4'hA, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Read Input pins (0x5)", test_num);
            reset_dut();

            input_pin = 4'h5;
            command = 2'b01;
            @(posedge clk);
            #1 command = 2'b00;
            @(posedge clk);

            #1;


            check_outputs(4'h0, 4'h5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data Persistence", test_num);
            reset_dut();


            command = 2'b10;
            output_data = 4'hF;
            @(posedge clk);


            command = 2'b01;
            input_pin = 4'hC;
            @(posedge clk);


            #1 command = 2'b00;
            input_pin = 4'h0;
            output_data = 4'h0;
            repeat(3) @(posedge clk);

            #1;


            check_outputs(4'hF, 4'hC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequential Updates", test_num);
            reset_dut();


            command = 2'b10;
            output_data = 4'h3;
            @(posedge clk);


            output_data = 4'h6;
            @(posedge clk);


            command = 2'b01;
            input_pin = 4'h9;
            @(posedge clk);

            #1 command = 2'b00;
            @(posedge clk);

            #1;


            check_outputs(4'h6, 4'h9);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("GPIO_Controller Testbench");
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
        input [3:0] expected_output_pin;
        input [3:0] expected_read_data;
        begin
            if (expected_output_pin === (expected_output_pin ^ output_pin ^ expected_output_pin) &&
                expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: output_pin=%h, read_data=%h",
                         output_pin, read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_pin=%h, read_data=%h",
                         expected_output_pin, expected_read_data);
                $display("  Got:      output_pin=%h, read_data=%h",
                         output_pin, read_data);
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
        $dumpvars(0,clk, command, input_pin, output_data, reset, output_pin, read_data);
    end

endmodule
