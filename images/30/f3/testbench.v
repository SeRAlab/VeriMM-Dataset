`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg channel_select;
    reg clk;
    reg [7:0] data_channel_0;
    reg [7:0] data_channel_1;
    reg read_enable;
    reg reset;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .data_channel_0(data_channel_0),
        .data_channel_1(data_channel_1),
        .read_enable(read_enable),
        .reset(reset),
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
            channel_select = 0;
            read_enable = 0;
            data_channel_0 = 8'h00;
            data_channel_1 = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Reading from Channel 0", test_num);
            data_channel_0 = 8'hA5;
            data_channel_1 = 8'h33;
            channel_select = 0;
            read_enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Reading from Channel 1", test_num);
            data_channel_0 = 8'hA5;
            data_channel_1 = 8'h5A;
            channel_select = 1;
            read_enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Read Enable Low (Inactive)", test_num);
            data_channel_0 = 8'hFF;
            data_channel_1 = 8'hEE;
            channel_select = 0;
            read_enable = 0;
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
            $display("Testcase %0d: Switching from Ch0 to Ch1", test_num);
            data_channel_0 = 8'h11;
            data_channel_1 = 8'h22;
            read_enable = 1;
            channel_select = 0;
            @(posedge clk);
            #1;
            channel_select = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Reset during active transfer", test_num);
            data_channel_0 = 8'hCC;
            read_enable = 1;
            channel_select = 0;
            @(posedge clk);
            #1 reset = 1;
            @(posedge clk);
            #1;
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
        $dumpvars(0,channel_select, clk, data_channel_0, data_channel_1, read_enable, reset, data_out);
    end

endmodule
