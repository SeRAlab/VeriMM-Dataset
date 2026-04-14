`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst_n;
    reg valid_frame;
    wire [7:0] buffer;
    wire data_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .data_in(data_in),
        .rst_n(rst_n),
        .valid_frame(valid_frame),
        .buffer(buffer),
        .data_ready(data_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        data_in = 8'h00;
        valid_frame = 0;
        repeat(2) @(posedge clk);
        #1 rst_n = 1;
        repeat(1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Single byte with valid frame", test_num);
        reset_dut();

        data_in = 8'hA5;
        valid_frame = 1;
        @(posedge clk);
        #1;


        #1;



        check_outputs(8'hA5, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Reset state check", test_num);
        reset_dut();


        #1;



        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Data without valid frame signal", test_num);
        reset_dut();

        data_in = 8'hFF;
        valid_frame = 0;
        @(posedge clk);
        #1;


        #1;



        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Multiple data cycles, check final result", test_num);
        reset_dut();


        data_in = 8'h11;
        valid_frame = 0;
        @(posedge clk);


        #1 data_in = 8'h22;
        valid_frame = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(8'h22, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Back-to-back valid frames", test_num);
        reset_dut();


        data_in = 8'hCC;
        valid_frame = 1;
        @(posedge clk);


        #1 data_in = 8'hDD;
        valid_frame = 1;
        @(posedge clk);
        #1;


        #1;



        check_outputs(8'hDD, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ethernet_mac_controller Testbench");
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
        input [7:0] expected_buffer;
        input expected_data_ready;
        begin
            if (expected_buffer === (expected_buffer ^ buffer ^ expected_buffer) &&
                expected_data_ready === (expected_data_ready ^ data_ready ^ expected_data_ready)) begin
                $display("PASS");
                $display("  Outputs: buffer=%h, data_ready=%b",
                         buffer, data_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: buffer=%h, data_ready=%b",
                         expected_buffer, expected_data_ready);
                $display("  Got:      buffer=%h, data_ready=%b",
                         buffer, data_ready);
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
        $dumpvars(0,clk, data_in, rst_n, valid_frame, buffer, data_ready);
    end

endmodule
