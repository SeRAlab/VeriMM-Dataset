`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] channel_select;
    reg clk;
    reg [7:0] data_in;
    reg enable;
    wire [7:0] memory_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .memory_out(memory_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            channel_select = 0;
            data_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data transfer on Channel 0", test_num);
            reset_dut();

            channel_select = 3'b000;
            data_in = 8'hAA;
            enable = 1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data transfer on Channel 7", test_num);
            reset_dut();

            channel_select = 3'b111;
            data_in = 8'h55;
            enable = 1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify Enable signal (Disabled)", test_num);
            reset_dut();

            channel_select = 3'b010;
            data_in = 8'hFF;
            enable = 0;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel switching from 1 to 4", test_num);
            reset_dut();


            channel_select = 3'b001;
            data_in = 8'h11;
            enable = 1;
            @(posedge clk);
            #2;


            channel_select = 3'b100;
            data_in = 8'h44;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h44);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Rapid data input change on Channel 3", test_num);
            reset_dut();

            channel_select = 3'b011;
            enable = 1;
            data_in = 8'hCC;
            @(posedge clk);
            #1;
            data_in = 8'hDD;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hDD);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero data transfer on Channel 5", test_num);
            reset_dut();

            channel_select = 3'b101;
            data_in = 8'h00;
            enable = 1;

            @(posedge clk);
            #2;

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
        input [7:0] expected_memory_out;
        begin
            if (expected_memory_out === (expected_memory_out ^ memory_out ^ expected_memory_out)) begin
                $display("PASS");
                $display("  Outputs: memory_out=%h",
                         memory_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: memory_out=%h",
                         expected_memory_out);
                $display("  Got:      memory_out=%h",
                         memory_out);
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
        $dumpvars(0,channel_select, clk, data_in, enable, memory_out);
    end

endmodule
