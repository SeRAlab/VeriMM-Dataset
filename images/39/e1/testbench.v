`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] channel_select;
    reg clk;
    reg enable;
    reg reset;
    wire data_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .data_valid(data_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            channel_select = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset state verification...");
            reset_dut();
            enable = 0;
            channel_select = 3'b000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Channel 0 selection with enable high...");
            reset_dut();
            enable = 1;
            channel_select = 3'b000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Channel 7 selection with enable high...");
            reset_dut();
            enable = 1;
            channel_select = 3'b111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Channel 4 selection with enable high...");
            reset_dut();
            enable = 1;
            channel_select = 3'b100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Enable low with channel selected...");
            reset_dut();
            enable = 0;
            channel_select = 3'b011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Reset priority during operation...");
            reset_dut();
            enable = 1;
            channel_select = 3'b101;
            @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning testcase007: Switching channels...");
            reset_dut();
            enable = 1;
            channel_select = 3'b001;
            @(posedge clk);
            channel_select = 3'b110;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("\nRunning testcase008: Immediate disable...");
            reset_dut();
            enable = 1;
            channel_select = 3'b010;
            @(posedge clk);
            enable = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
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
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_data_valid;
        begin
            if (expected_data_valid === (expected_data_valid ^ data_valid ^ expected_data_valid)) begin
                $display("PASS");
                $display("  Outputs: data_valid=%b",
                         data_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_valid=%b",
                         expected_data_valid);
                $display("  Got:      data_valid=%b",
                         data_valid);
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
        $dumpvars(0,channel_select, clk, enable, reset, data_valid);
    end

endmodule
