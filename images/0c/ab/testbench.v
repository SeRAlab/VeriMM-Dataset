`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] dir;
    reg read_enable;
    reg rst;
    reg [4:0] write_data;
    wire [4:0] output_status;
    wire [4:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .dir(dir),
        .read_enable(read_enable),
        .rst(rst),
        .write_data(write_data),
        .output_status(output_status),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            dir = 0;
            write_data = 0;
            read_enable = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Verify Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(5'b00000, 5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: All Pins as Outputs", test_num);
            reset_dut();

            dir = 5'b11111;
            write_data = 5'h1A;
            read_enable = 1;
            @(posedge clk);
            #1;



            #1;




            check_outputs(5'h1A, 5'h1A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: All Pins as Inputs", test_num);
            reset_dut();

            dir = 5'b00000;
            write_data = 5'h1F;
            read_enable = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(5'b00000, 5'b00000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Mixed Configuration (10101)", test_num);
            reset_dut();

            dir = 5'b10101;
            write_data = 5'b11111;
            read_enable = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(5'b10101, 5'b10101);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Read Enable Toggle", test_num);
            reset_dut();

            dir = 5'b11111;
            write_data = 5'h0F;
            read_enable = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(5'h0F, 5'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Dynamic Direction Change", test_num);
            reset_dut();


            dir = 5'b11111;
            write_data = 5'b10101;
            @(posedge clk);


            dir = 5'b00000;
            read_enable = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(5'b00000, 5'b00000);
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
        input [4:0] expected_output_status;
        input [4:0] expected_read_data;
        begin
            if (expected_output_status === (expected_output_status ^ output_status ^ expected_output_status) &&
                expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: output_status=%h, read_data=%h",
                         output_status, read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_status=%h, read_data=%h",
                         expected_output_status, expected_read_data);
                $display("  Got:      output_status=%h, read_data=%h",
                         output_status, read_data);
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
        $dumpvars(0,clk, dir, read_enable, rst, write_data, output_status, read_data);
    end

endmodule
