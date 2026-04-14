`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] channel_select;
    reg clk;
    reg [7:0] data_in;
    reg [15:0] mem_address;
    reg reset;
    reg start;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .data_in(data_in),
        .mem_address(mem_address),
        .reset(reset),
        .start(start),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            channel_select = 0;
            mem_address = 0;
            data_in = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Channel 0 transfer", test_num);
            channel_select = 3'd0;
            mem_address = 16'h1000;
            data_in = 8'hA5;
            start = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
            start = 0;
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Channel 7 transfer", test_num);
            channel_select = 3'd7;
            mem_address = 16'hFFFF;
            data_in = 8'h5A;
            start = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h5A);
            start = 0;
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: No transfer when start is low", test_num);
            channel_select = 3'd3;
            mem_address = 16'h2000;
            data_in = 8'hFF;
            start = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Channel 4 transfer with address 0x1234", test_num);
            channel_select = 3'd4;
            mem_address = 16'h1234;
            data_in = 8'hBC;
            start = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hBC);
            start = 0;
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Sequential multi-channel check", test_num);


            channel_select = 3'd1;
            data_in = 8'h11;
            start = 1;
            @(posedge clk);
            #1;


            channel_select = 3'd2;
            data_in = 8'h22;
            start = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h22);
            start = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        $dumpvars(0,channel_select, clk, data_in, mem_address, reset, start, data_out);
    end

endmodule
