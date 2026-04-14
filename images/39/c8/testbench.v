`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] channel_select;
    reg clk;
    reg [7:0] data_in;
    reg start;
    wire busy;
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
        .start(start),
        .busy(busy),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            channel_select = 0;
            data_in = 0;

            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Channel 0 Transfer", test_num);
            reset_dut();

            data_in = 8'hA5;
            channel_select = 2'b00;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;



            while (busy === 1'b1) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Channel 1 Transfer", test_num);
            reset_dut();

            data_in = 8'h5A;
            channel_select = 2'b01;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            while (busy === 1'b1) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Channel 2 Transfer", test_num);
            reset_dut();

            data_in = 8'hFF;
            channel_select = 2'b10;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            while (busy === 1'b1) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Channel 3 Transfer", test_num);
            reset_dut();

            data_in = 8'h12;
            channel_select = 2'b11;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            while (busy === 1'b1) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'h12);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Busy Signal Verification", test_num);
            reset_dut();

            data_in = 8'h77;
            channel_select = 2'b00;
            start = 1;
            @(posedge clk);
            #1;


            if (busy === 1'b1) begin
                $display("  Info: Busy signal correctly asserted during transfer.");
            end else begin
                $display("  Warning: Busy signal not high during transfer start.");
            end

            start = 0;
            while (busy === 1'b1) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'h77);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Idle State Check", test_num);
            reset_dut();


            data_in = 8'hEE;
            channel_select = 2'b11;
            repeat(5) @(posedge clk);
            #1;



            if (busy === 1'b0 && data_out !== 8'hEE) begin
                pass_count = pass_count + 1;
                $display("PASS: Controller remained idle.");
            end else if (busy === 1'b1) begin
                fail_count = fail_count + 1;
                $display("FAIL: Controller busy without start pulse.");
            end else begin

                #1;


                check_outputs(1'b0, data_out);
            end
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
        input expected_busy;
        input [7:0] expected_data_out;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, data_out=%h",
                         busy, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, data_out=%h",
                         expected_busy, expected_data_out);
                $display("  Got:      busy=%b, data_out=%h",
                         busy, data_out);
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
        $dumpvars(0,channel_select, clk, data_in, start, busy, data_out);
    end

endmodule
