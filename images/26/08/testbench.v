`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_ch1;
    reg [7:0] data_ch2;
    reg reset;
    reg start_ch1;
    reg start_ch2;
    wire [7:0] destination;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .data_ch1(data_ch1),
        .data_ch2(data_ch2),
        .reset(reset),
        .start_ch1(start_ch1),
        .start_ch2(start_ch2),
        .destination(destination),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start_ch1 = 0;
            start_ch2 = 0;
            data_ch1 = 8'h00;
            data_ch2 = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Channel 1 Transfer", test_num);
            reset_dut();

            data_ch1 = 8'hAA;
            start_ch1 = 1;
            @(posedge clk);
            start_ch1 = 0;


            wait(done == 1'b1);
            #1;
            #1;

            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Channel 2 Transfer", test_num);
            reset_dut();

            data_ch2 = 8'h55;
            start_ch2 = 1;
            @(posedge clk);
            start_ch2 = 0;


            wait(done == 1'b1);
            #1;
            #1;

            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simultaneous Start (Priority check)", test_num);
            reset_dut();

            data_ch1 = 8'h11;
            data_ch2 = 8'h22;
            start_ch1 = 1;
            start_ch2 = 1;
            @(posedge clk);
            start_ch1 = 0;
            start_ch2 = 0;


            wait(done == 1'b1);
            #1;

            #1;


            check_outputs(8'h11, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset during transfer", test_num);
            reset_dut();

            data_ch1 = 8'hFF;
            start_ch1 = 1;
            @(posedge clk);
            start_ch1 = 0;


            #2 reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Consecutive Transfers (CH2 then CH1)", test_num);
            reset_dut();


            data_ch2 = 8'hCC;
            start_ch2 = 1;
            @(posedge clk);
            start_ch2 = 0;
            wait(done == 1'b1);


            @(posedge clk);
            data_ch1 = 8'hDD;
            start_ch1 = 1;
            @(posedge clk);
            start_ch1 = 0;
            wait(done == 1'b1);

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
        input [7:0] expected_destination;
        input expected_done;
        begin
            if (expected_destination === (expected_destination ^ destination ^ expected_destination) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: destination=%h, done=%b",
                         destination, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: destination=%h, done=%b",
                         expected_destination, expected_done);
                $display("  Got:      destination=%h, done=%b",
                         destination, done);
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
        $dumpvars(0,clk, data_ch1, data_ch2, reset, start_ch1, start_ch2, destination, done);
    end

endmodule
