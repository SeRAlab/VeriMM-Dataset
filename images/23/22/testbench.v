`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg write_en;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .write_en(write_en),
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
        write_en = 0;
        data_in = 8'h00;
        @(posedge clk);
        #2 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Write and Read Operation", test_num);
        reset_dut();


        data_in = 8'hA5;
        write_en = 1;
        @(posedge clk);


        #1 write_en = 0;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify write_en logic", test_num);
        reset_dut();


        data_in = 8'h55;
        write_en = 1;
        @(posedge clk);


        #1;
        data_in = 8'hAA;
        write_en = 0;
        @(posedge clk);


        #1;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Asynchronous/Synchronous Reset Check", test_num);
        reset_dut();


        data_in = 8'hFF;
        write_en = 1;
        @(posedge clk);


        #1;
        rst = 1;
        @(posedge clk);


        #1;
        rst = 0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple Sequential Writes", test_num);
        reset_dut();

        write_en = 1;

        data_in = 8'h11;
        @(posedge clk);
        #1;

        data_in = 8'h22;
        @(posedge clk);
        #1;

        data_in = 8'h33;
        @(posedge clk);
        #1;

        write_en = 0;
        #1;

        check_outputs(8'h33);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary values (0x00 and 0xFF)", test_num);
        reset_dut();


        data_in = 8'hFF;
        write_en = 1;
        @(posedge clk);
        #1;


        data_in = 8'h00;
        @(posedge clk);
        #1;

        write_en = 0;
        #1;

        check_outputs(8'h00);
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
        $dumpvars(0,clk, data_in, rst, write_en, data_out);
    end

endmodule
